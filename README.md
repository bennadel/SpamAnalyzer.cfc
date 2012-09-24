
# SpamAnalyzer.cfc

by Ben Nadel ([www.bennadel.com][1])

SpamAnalyzer.cfc is a ColdFusion (and set of data files) that helps analyze 
user-submitted content. Specifically geared for user-submitted comments, the
SpamAnalyzer.cfc can look at:

* Author names
* Author URLs
* Author content (ie. comment)

... to determine if they are valid; or, if they are "spam". 

The analysis is powered by a set of data files that contain Regular 
Expressions. Each regular expression is run against the given user input and, 
if any patterns match, the user input can be considered spam.

Behind the scenes, each individual regular expression pattern is being compiled
into an instance of Java's java.util.regex.Pattern class. This means that the
regular expression patterns can make use of the robust syntax supported by 
Java; this includes, but is not limited to, negative and positive look behinds
as well as negative and positive look aheads.

## Why No Email Matching?

While I think it's completely valid to block certain email addresses, that 
feels more like a blacklisting issue for an application, not an analysis for 
user-supplied content.

## Why No IP Address Matching?

Due to the relatively dynamic nature of IP addresses, I have found them to
cause more false matches than true spam protection. And, since they cannot be
analyzed, they should be handled externally to the SpamAnalyzer.cfc.


[1]: http://www.bennadel.com