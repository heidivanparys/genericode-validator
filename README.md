# genericode-validator

genericode-validator is a tool for validating genericode files according to:

1. the genericode XML schema;
2. the genericode document rules;
3. additional rules specified in this repository.

## About the underlying standards and tools

### Genericode

[Genericode](https://docs.oasis-open.org/codelist/genericode/v1.0/genericode-v1.0.html), also known as Code List Representation, is “a single semantic model for code lists and accompanying XML serialization that is designed to IT-enable and standardize the publication of machine-readable code list information and its interchange between systems”[^1]. Genericode is developed by the [Organization for the Advancement of Structured Information Standards (OASIS)](https://www.oasis-open.org/). See the [website of the OASIS Code List Representation TC](https://www.oasis-open.org/committees/codelist/) for more information.

[^1]: Source: [Genericode Approved as an OASIS Standard](https://www.oasis-open.org/2023/02/01/genericode-approved-as-an-oasis-standard/)

## Installation

This tool relies on the presence of Java, the XProc processor Morgana, the XSLT processor Saxon, and the Schematron implementation schxslt:

- Clone the repository on your local machine, no releases are available at the moment.
- Ensure you have a Java 8 or Java 11 installation.
- Download and install [Morgana](https://www.xml-project.com/morganaxproc-iiise.html), add the path to the folder where you installed Morgana to your user's _Path_ environment variable.
- Download the [Schematron processor schxslt](https://github.com/schxslt/schxslt/releases/latest) (schxslt-x.y.z-xslt-only.zip), extract the zip file and move the contents to an appropriate place.
- Download the latest version of the [XSLT processor Saxon](https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/) and place the jar file Saxon-HE-x.y.jar in the MorganaXProc-IIIse\MorganaXProc-IIIse_lib folder.

## Usage

A validation report for a genericode file is created by processing the genericode file in a pipeline written in [XProc](https://xproc.org/).

Create a file morgana-config.xml file in folder `local-scripts`. Customise the path in element `path_to_SchXSLT_2`, adjust the value of element `xslt-connector` to match the value specified for your version of Saxon as specified in https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_2, and make sure to add a media type mapping for genericode files (*.gc), see https://www.xml-project.com/manual/ch02.html#configuration_s1_5.

```xml
<morgana-config xmlns="http://www.xml-project.com/morganaxproc">	
	<!-- See "Selecting the XSLTConnector" on https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_2 -->
	<XSLTValidationMode>LAX</XSLTValidationMode>
	<xslt-connector>saxon12-3</xslt-connector>
    
	<!-- See "Selecting the Schematron processor" on https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_5 -->
	<schematron-connector>schxslt</schematron-connector>
	<path_to_SchXSLT_2>file:///path/to/schxslt-x.y.z/2.0</path_to_SchXSLT_2>
    
	<mediatype-mapping>
		<map file-extension="gc" media-type="application/xml" />
	</mediatype-mapping>	
    
</morgana-config>
```

Create a batch file `validate-genericode-html.bat` in folder `local-scripts` as follows, adjust the paths to the input and output:

```bat
Morgana -config=local-scripts\morgana-config.xml src\main\xml\xproc\validate-genericode-html.xpl -input:source="C:\path\to\genericode-file.gc" -output:result="C:\path\to\report.html" -option:assert-valid=false
```

Run `validate-genericode-html.bat` from the root directory of the repository:

```bat
local-scripts\validate-genericode-html.bat
```

Open report.html in a browser.

## Development

### Running the tests

On Windows, the XSpec Schematron tests can run using the batch files in the [scripts folder](/scripts). Run the batch files from the root directory of the repository, for instance:

```bat
scripts\run-schematron-tests.bat
```



