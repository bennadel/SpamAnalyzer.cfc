<cfscript>

component 
	output = "false"
	hint = "I analyze user input to help determine if it is SPAM or valid content."
	{


	// I return a component instance, configured to use the Regular Expression patterns defined
	// in the given data files. These files need to be read-only - they will not be modified by
	// the SpamAnalyzer.cfc.
	function init(
		String userNameDataFilePath,
		String userUrlDataFilePath,
		String userContentDataFilePath
		) {

		// Load the data files and compile the patterns.
		variables.patterns = {
			name = this._loadAndCompilePatterns( userNameDataFilePath ),
			url = this._loadAndCompilePatterns( userUrlDataFilePath ),
			content = this._loadAndCompilePatterns( userContentDataFilePath )
		};

		// Return this object reference.
		return( this );

	}


	// ---
	// PUBLIC METHODS.
	// ---


	// I look at the given name and analyze it for spam content.
	function analyzeUserContent( String userContent ) {

		// Run all the given regular expression patterns against the given input.
		var response = this._checkInputAgainstPatterns( 
			"userContent",
			userContent,
			variables.patterns.content
		);

		return( response );

	}


	// I look at the given name and analyze it for spam content.
	function analyzeUserName( String userName ) {

		// Run all the given regular expression patterns against the given input.
		var response = this._checkInputAgainstPatterns( 
			"userName",
			userName,
			variables.patterns.name
		);

		return( response );

	}


	// I look at the given name and analyze it for spam content.
	function analyzeUserUrl( String userUrl ) {

		// Run all the given regular expression patterns against the given input.
		var response = this._checkInputAgainstPatterns( 
			"userUrl",
			userUrl,
			variables.patterns.url
		);

		return( response );

	}


	// ---
	// PRIVATE METHODS.
	// ---


	// I check the given input against the given set of patterns.
	function _checkInputAgainstPatterns( 
		String inputType, 
		String input, 
		Array patterns
		) {

		// Create the initial response (defaults to not spam).
		var response = this._createAnalysisResponse( inputType, input );

		// Convert to a Java String in order to make sure that we have the appropriate type for the
		// matcher() method called down below. ColdFusion already stores this string value as a 
		// Java string; however, we're making this explicit here in case anything should ever change.
		input = createObject( "java", "java.lang.String" ).init(
			javaCast( "string", input )
		);

		// Calculate the number of patterns - doing this here so this value doesn't have to be
		// re-calculated for every iteration of the following loop.
		var patternCount = arrayLen( patterns );

		// Loop over the patterns to apply each, in turn, to the user input.
		for ( var i = 1 ; i <= patternCount ; i++ ) {

			var pattern = patterns[ i ];

			// Check to see if this pattern matches the user input.
			if ( pattern.matcher( input ).find() ) {

				// Update the response to represent a spam input.
				response.isSpam = true;
				response.pattern = pattern;

				// Return the response - there's not need to continue analyzing the input.
				return( response );

			}

		}

		// If we made it this far, then none of the spam pattens could be matched against the
		// user's input. Return the default response.
		return( response );

	}


	// I create the standardized response for analysis.
	function _createAnalysisResponse( String inputType, String input ) {

		var response = {};

		// I flag the user input as spam or not spam.
		response.isSpam = false;

		// I echo the type of input being analzed (ex. userContnt ).
		response.inputType = inputType;

		// I echo the user input being analyzed.
		response.input = input;

		// I am the pattern that matched the user input (causing the content to be flagged 
		// as being spam).
		response.pattern = "";
			
		return( response );

	}


	// I load and compile the regular expression patterns found in the given file.
	function _loadAndCompilePatterns( filepath ) {

		var fileContent = fileRead( filepath );

		// Split the file content on the new line. This will give us each pattern on it's own line.
		var patterns = listToArray( fileContent, (chr( 13 ) & chr( 10 )) );

		// Get the number of patterns so that this doesn't have to be re-calcualted on each iteration
		// of the proceeding loop.
		var patternCount = arrayLen( patterns );

		// Loop over the patterns to clean them up and compile them into Java pattersn. Each pattern 
		// should be trimmed and made case-insensitive.
		for ( var i = 1 ; i <= patternCount ; i++ ) {

			patterns[ i ] = createObject( "java", "java.util.regex.Pattern" ).compile(
				javaCast( 
					"string", 
					("(?i)" & trim( patterns[ i ] )) 
				)
			);
			
		}

		return( patterns );

	}


}

</cfscript>