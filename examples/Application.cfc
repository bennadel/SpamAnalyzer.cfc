<cfscript>

component 
	output = "false"
	hint = "I define the applications settings and event handlers."
	{


	// Define the application settings.
	this.name = hash( getCurrentTemplatePath() );
	this.applicationTimeout = createTimeSpan( 0, 0, 5, 0 );
	this.sessionManagement = false;

	// Get the current directory and the root directory.
	this.appDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
	this.projectDirectory = (this.appDirectory & "../");

	// Map the LIB directory so we can create our components.
	this.mappings[ "/lib" ] = (this.projectDirectory & "lib");


	// I initialize the request.
	function onRequestStart() {

		// Get a reference to where our data files are stored.
		var patternsDirectory = (this.projectDirectory & "patterns/");

		// Create an instance of our spam analyzer for the form submission. We are doing this in
		// the onRequestStart() event handler (as opposed to the onApplicationStart() event 
		// handler) so that people can edit the pattern files and see the changes take effect
		// immediately. Normally, this component would be created and cached within the 
		// application scope, or some other dependency injection framework.
		request.spamAnalyzer = new lib.SpamAnalyzer(
			userNameDataFilePath = (patternsDirectory & "names.txt"),
			userUrlDataFilePath = (patternsDirectory & "urls.txt"),
			userContentDataFilePath = (patternsDirectory & "content.txt")
		);

		// Return true so the request can continue to load.
		return( true );

	}


}

</cfscript>