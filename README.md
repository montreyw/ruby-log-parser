# ruby-log-parser 
Parsing a servers log file to determine which front-end or back-end servers may be the culprits for slow performance

This Ruby file parses a log file which contains trasactional records for front-end and back-end servers. This script will determine the response time of transctions, deteremined by UUID, and then sorting these trasctions times to ultimately determine which servers may be slow.

