Run this docker run command on the directory you wish to check your code.  The report will be in the same directory = semgrep-results.json


docker run --rm -v "${PWD}:/src" semgrep/semgrep semgrep scan --config auto --json /src > semgrep-results.json