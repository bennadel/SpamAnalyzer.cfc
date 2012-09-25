
<!--- Param the form inputs. --->
<cfparam name="form.submitted" type="boolean" default="false" />
<cfparam name="form.userName" type="string" default="Cheap Viagra" />
<cfparam name="form.userUrl" type="string" default="" />
<cfparam name="form.userContent" type="string" default="Buy cheap WOW gold - best prices, around. Warcraft is the best!" />


<!--- ----------------------------------------------------- --->
<!--- ----------------------------------------------------- --->


<!--- Default the high-level responses. --->
<cfset isUserNameSpam = false />
<cfset isUserUrlSpam = false />
<cfset isUserContentSpam = false />

<!--- Check to see if the form has been submitted - we'll look at the input. --->
<cfif form.submitted>

	<!--- Analyze the user input. --->
	<cfset userNameResponse = request.SpamAnalyzer.analyzeUserName( form.userName ) />
	<cfset userUrlResponse = request.SpamAnalyzer.analyzeUserUrl( form.userUrl ) />
	<cfset userContentResponse = request.SpamAnalyzer.analyzeUserContent( form.userContent ) />

	<!--- Flag the indiviual response types. --->
	<cfset isUserNameSpam = userNameResponse.isSpam />
	<cfset isUserUrlSpam = userUrlResponse.isSpam />
	<cfset isUserContentSpam = userContentResponse.isSpam />

</cfif>


<!--- ----------------------------------------------------- --->
<!--- ----------------------------------------------------- --->


<!--- Reset the output buffer. --->
<cfcontent type="text/html; charset=utf-8" />

<cfoutput>

	<!doctype html>
	<html>
	<head>
		<meta charset="utf-8" />
		<title>Detecting Spam With SpamAnalyzer.cfc</title>
	</head>
	<body>

		<h1>
			Detecting Spam With SpamAnalyzer.cfc
		</h1>

		<form action="#cgi.script_name#" method="post">

			<!--- Flag the form submission. --->
			<input type="hidden" name="submitted" value="true" />

			<p>
				User Name:<br />
				<input type="text" name="userName" value="#htmlEditFormat( form.userName )#" size="30" /><br />

				<!--- Check to see if the username has been flagged as spam. --->
				<cfif isUserNameSpam>

					<strong>Flagged As Spam:</strong> #userNameResponse.pattern#

				</cfif>
			</p>

			<p>
				User Url:<br />
				<input type="text" name="userUrl" value="#htmlEditFormat( form.userUrl )#" size="30" /><br />

				<!--- Check to see if the user URL has been flagged as spam. --->
				<cfif isUserUrlSpam>

					<strong>Flagged As Spam:</strong> #userUrlResponse.pattern#

				</cfif>
			</p>

			<p>
				User Content:<br />
				<textarea name="userContent" rows="10" cols="40">#htmlEditFormat( form.userContent )#</textarea><br />

				<!--- Check to see if the user content has been flagged as spam. --->
				<cfif isUserContentSpam>

					<strong>Flagged As Spam:</strong> #userContentResponse.pattern#

				</cfif>
			</p>

			<p>
				<input type="submit" value="Analyze User Input" />
			</p>

		</form>

	</body>
	</html>

</cfoutput>