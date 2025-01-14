
/*
 * Copyright (c) 2001, Webalo, Inc. All rights reserved.
 * @author Doug Baron
 * @version 1.0
 */

package com.webalo.runtime.device;

import java.util.*;
import java.io.*;
import javax.swing.text.html.HTML.*;
import com.webalo.runtime.*;
import com.webalo.runtime.data.*;
import com.webalo.runtime.http.*;
import com.webalo.util.*;
import com.jclark.xsl.sax.*;
import org.xml.sax.*;
import java.net.URL;

/**
 * Tasklet device User Interaction support. Responsible for processing 
 * user inputs and presenting tasklet and other runtime-generated 
 * display elements.
 */
public abstract class AbstractDeviceUI implements DeviceUI {

	protected static final String SESSION_KEY_NAME = "session";

	private HttpRequest request;
	private Thread sleepingThread = null;
	protected UIDocument document;
	private boolean waitingForUserInput;
	private String sessionKey;
	private boolean havePendingDisplay;

	public AbstractDeviceUI(HttpRequest request) {
		this.request = request;
		this.document = new UIDocumentImpl();
		this.havePendingDisplay = false;

		//createGreeting();
	}

	/**
	 * If a request is associated with this <code>DeviceUI</code>, returns
	 * it, otherwise returns <code>null</code>
	 */
	public HttpRequest getRequest() { return this.request; }

	/**
	 * Returns the URL of the xsl stylesheet for this device
	 */
	abstract URL getStylesheetUrl();

	public void display(UIDocument document) {
		
		this.document.importDocument(document);
		havePendingDisplay = true;
	}

	public void debug(String s) {

		document.appendChild(document.createText(s + "\n"));
		havePendingDisplay = true;
	}

	/*
	public void setPageTitle(String title) {
		document.setAttribute("title", title);
	}
	*/

	protected String getContent(boolean needContinuation) {

		if (needContinuation)
			document.setAttribute(SESSION_KEY_NAME, getRequestSessionKey());

		String xml = this.document.toXML();
	Debug.println(this, "XML: " + xml);
		String html = transform(xml);
	//Debug.println(this, "html: " + html);
		return html;
	}

	public void flush(boolean needContinuation) {
		if (havePendingDisplay) {
			try {
	Debug.println(this, "......replying...." + this.toString());
				request.reply("text/html", this.getContent(needContinuation));
				this.document = new UIDocumentImpl(); //reset
				havePendingDisplay = false;
			}
			catch (Exception e) { Debug.println(e); Debug.dumpStack(this); }
		}
	}

	public DataElem getUserInputData() {
		
		flush(true);

		this.sleepingThread = Thread.currentThread();
		try {
			while (!Thread.interrupted()) {
				Debug.println(this, this.getRequestSessionKey() + " waiting...");
				Thread.sleep(3000);
				Debug.println(this, "done.");
			}
		}
		catch (InterruptedException e) { } //Debug.println(e.toString()); }

		return getRequestInputData();
	}

/*
	private void setRequest(HttpRequest request) {
		this.request = request;
	}
*/

/*
	public void resume(HttpRequest request) {
		Debug.println(this, "resume!!!!!! @...");

		this.setRequest(request);
		this.sleepingThread.interrupt();
	}
*/

	public void init(String sessionKey) { this.sessionKey = sessionKey; }

	public String getRequestSessionKey() { return this.sessionKey; }

	/**
	 * Retrieve all input data provided by the user in reponse to the
	 * page that has been displayed.
	 * @return A <code>CompositeDataElem</code> with fields named for the
	 * prompts that were supplied to <code>requestUserInput</code>
	 */
	public DataElem getRequestInputData() {

		MutableDataElem queryValues = null;
		try {
			MutableDataElemType type = new MutableCompositeDataElemType("");
				//DataElemTypeSystem.createCompositeDataElemType(DataElemTypeSystem.STRING_TYPE);
			HtmlFormContent formContent = new HtmlFormContent(request);
			HashMap queryData = formContent.getValueMap();

			if (queryData == null) {
				queryValues = new MutablePrimitiveDataElem(DataElemTypeSystem.STRING_TYPE);
			}
			else {
				queryData.remove(SESSION_KEY_NAME);
				Set keySet = queryData.keySet();
				String[] keys = (String[])keySet.toArray(new String[keySet.size()]);

				if (keys.length < 1)
					queryValues = new MutablePrimitiveDataElem(DataElemTypeSystem.STRING_TYPE);
				else {
					for (int i = 0; i < keys.length; i++) {
						type.addField(keys[i], DataElemTypeSystem.STRING_TYPE);
					}
			
					queryValues = new MutableCompositeDataElem(type.toImmutable());

					for (int i = 0; i < keys.length; i++) {
						String s = (String)queryData.get(keys[i]);
						if (s != null) {
							DataElem queryValue = new PrimitiveDataElem(
									DataElemTypeSystem.STRING_TYPE,
									(String)queryData.get(keys[i]));

							queryValues.setField(keys[i], queryValue);
						}
					}

					/*
					DataElem hack = queryValues.getField("input");
					if (hack != null)
						return hack;
					*/
				}
			}
			return queryValues.toImmutable();
		}
		catch (Exception e) {
			Debug.println(this, e.toString());
			return null;
		}
	}

	public WlPath getRequestTasklet() {

		HttpUri uri = request.getRequestUri();
		String taskletPath = uri.getPath().toLowerCase();
		return new WlPath(taskletPath);
	}

	public String getTaskletHref(WlPath taskletPath) {
		return taskletPath.toString();
	}
	
	public DeviceUI resume(DeviceUI resumptionDeviceUi) { 

		this.request = ((AbstractDeviceUI)resumptionDeviceUi).getRequest();

		if (this.sleepingThread == null) {
	Debug.println(this, "NOT a continuation!");
			return resumptionDeviceUi;
		}

	Debug.println(this, "YES a continuation, waking...");
		this.sleepingThread.interrupt();
		sleepingThread = null;
		return this;
	}
	
	public UserIdentity getUserIdentity() {
		return new UserIdentity("Dr. Hansen");
	}

	public void displaySessionNotFound() {

		String s = "Session Not Found.";
		document.appendChild(document.createText(s));
		havePendingDisplay = true;
		flush(false);
	}

	private void createGreeting() {

		String s = "Welcome " + getUserIdentity().toString() + "<br/>";
		document.appendChild(document.createText(s));
		this.havePendingDisplay = true;
	}

	static void printSAXParseException(SAXParseException e) {
		String systemId = e.getSystemId();
		int lineNumber = e.getLineNumber();
		if (systemId != null)
			System.err.print(systemId + ":");
		if (lineNumber >= 0)
			System.err.print(lineNumber + ":");
		if (systemId != null || lineNumber >= 0)
			System.err.print(" ");
		System.err.println(e.getMessage());
	}

	static class ErrorHandlerImpl implements ErrorHandler {
		public void warning(SAXParseException e) {
			printSAXParseException(e);
		}
		public void error(SAXParseException e) {
			printSAXParseException(e);
		}
		public void fatalError(SAXParseException e) throws SAXException {
			throw e;
		}
	}

	private String transform(String xml) {
		XSLProcessorImpl xsl = new XSLProcessorImpl();
		xsl.setErrorHandler(new ErrorHandlerImpl());
		Parser parserObj = new com.jclark.xml.sax.CommentDriver();
		xsl.setParser(parserObj);

		OutputMethodHandlerImpl outputMethodHandler = new OutputMethodHandlerImpl(xsl);
		xsl.setOutputMethodHandler(outputMethodHandler);

		URL stylesheet = getStylesheetUrl();
		if (stylesheet == null) {
			Debug.dumpStack(this);
			return ("<html><body><h4>couldn't load stylesheet</h4></body></html>");
		}
		
		return transformData(xsl, outputMethodHandler, xml, stylesheet);
	}

	private String transformData(XSLProcessor xsl,
			OutputMethodHandlerImpl outputMethodHandler,
			String inputData,
			URL stylesheetUrl) {

		InputSource source = new InputSource(new StringReader(inputData));
		InputSource stylesheet = new InputSource(stylesheetUrl.toString());

		ByteArrayOutputStream out = new ByteArrayOutputStream();
		Destination dest = new FixedOutputStreamDestination(out);
		outputMethodHandler.setDestination(dest);

		boolean success = transform(xsl, stylesheet, source);

		try {
			return out.toString("UTF-8");
		} catch (UnsupportedEncodingException e) {return null;}
	}

	private boolean transformFile(XSLProcessor xsl,
			OutputMethodHandlerImpl outputMethodHandler,
			File inputFile,
			File stylesheetFile,
			File outputFile) {

		Destination dest = new FileDestination(outputFile);
		outputMethodHandler.setDestination(dest);

		return transform(xsl,
			 fileInputSource(stylesheetFile),
			 fileInputSource(inputFile));
	}

	private boolean transform(XSLProcessor xsl,
			InputSource stylesheetSource,
			InputSource inputSource) {

		try {
			xsl.loadStylesheet(stylesheetSource);
			xsl.parse(inputSource);
			return true;
		}
		catch (SAXParseException e) {
			printSAXParseException(e);
		}
		catch (SAXException e) {
			System.err.println(e.getMessage());
		}
		catch (IOException e) {
			System.err.println(e.toString());
		}
		return false;
	}

	private InputSource fileInputSource(File file) {
		String path = file.getAbsolutePath();
		String fSep = System.getProperty("file.separator");
		
		if (fSep != null && fSep.length() == 1)
			path = path.replace(fSep.charAt(0), '/');
		if (path.length() > 0 && path.charAt(0) != '/')
			path = '/' + path;
		try {
			return new InputSource(new URL("file", "", path).toString());
		}
		catch (java.net.MalformedURLException e) {
			/* According to the spec this could only happen if the file
			protocol were not recognized. */
			throw new Error("unexpected MalformedURLException");
		}
	}

/*
	public String getSessionContinuationUrl() {
		Debug.println( "continue?session=" + java.net.URLEncoder.encode(session.getKey()));
		return "continue?session=" + java.net.URLEncoder.encode(session.getKey());
	}
*/

}

/**
	Destination class for OutputStream that patches a bug in 
	OutputStreamDestination, by calling setEncoding in getOutputStream
 */
class FixedOutputStreamDestination 
	extends com.jclark.xsl.sax.OutputStreamDestination {
	//final private OutputStream outputStream;

	public FixedOutputStreamDestination(OutputStream outputStream) {
		super(outputStream);
		//this.outputStream = outputStream;
	}

	public OutputStream getOutputStream(String contentType, String encoding) {
		setEncoding(encoding);
		return super.getOutputStream(contentType, encoding);
		//return outputStream;
	}
}

