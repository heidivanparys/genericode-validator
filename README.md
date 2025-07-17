# genericode-validator

genericode-validator is a tool for validating genericode files according to:

1. the genericode XML schema;
2. the genericode document rules;
3. additional rules specified in this repository.

## Installation

The installation instructions assume that the installation is done on a Windows computer.

- genericode-validator: clone this repository on your local machine (no releases are available at the moment);
- Java:
  - Ensure you have a Java 11 (or later) installation;
  - Ensure that environment variable `JAVA_HOME` is set and points to that Java installation;
- Saxon:
  - Download and unzip the XSLT 3 processor [Saxon](https://github.com/Saxonica/Saxon-HE/releases/latest) into a suitable directory;
  - Set environment variable `SAXON_CP` to the location of the principal Saxon jar file, saxon-he-x.y.jar;
- Morgana:
  - Download and unzip the XProc 3 processor [Morgana](https://www.xml-project.com/morganaxproc-iiise.html) into a suitable directory;
  - Add the path to that directory to your user's _Path_ environment variable;
  - Place a _copy_ of jar file saxon-he-x.y.jar in the MorganaXProc-IIIse\MorganaXProc-IIIse_lib folder.
- schxslt:
  - Download the [Schematron processor schxslt](https://codeberg.org/SchXslt/schxslt) (schxslt-x.y.z-xslt-only.zip), extract the zip file and move the contents to an appropriate place.
- XSpec (only needed for development):
  - Download/clone the [unit testing framework XSpec](https://github.com/xspec/xspec/)
  - Set the environment variable `XSPEC_HOME` to the location where XSpec is stored.
  
## Configuration of Morgana

Create a file `morgana-config.xml` file in folder `local-scripts`.

```xml
<morgana-config xmlns="http://www.xml-project.com/morganaxproc">	
	<XSLTValidationMode>LAX</XSLTValidationMode>
	
	<!-- See "Selecting the XSLTConnector" on https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_2 -->
	<xslt-connector>saxon12-3</xslt-connector>
    
	<!-- See "Selecting the Schematron processor" on https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_5 -->
	<schematron-connector>schxslt</schematron-connector>
	<path_to_SchXSLT_2>file:///path/to/schxslt-x.y.z/2.0</path_to_SchXSLT_2>
    
   <!-- See "Adding media type mappings" on https://www.xml-project.com/manual/ch02.html#configuration_s1_5 -->
	<mediatype-mapping>
		<map file-extension="gc" media-type="application/xml" />
	</mediatype-mapping>	
    
</morgana-config>
```

Customize `morgana-config.xml`:

* Customise the value of element `xslt-connector` to match the value specified for your version of Saxon as specified in https://www.xml-project.com/manual/ch02.html#configuration_s1_1_s2_2;
* Customise the path in element `path_to_SchXSLT_2`.

## Configuration check

To check your configuration, run batch file `print-configuration.bat` in folder `scripts` from the _root directory_ of the working tree of your local repository:

```bat
scripts\print-configuration.bat
```

The output will show the versions of the applications needed by the sripts.

> [!NOTE]
> XSpec is only needed for running the tests.

## Usage

The usage instructions assume that the application is used on a Windows computer.

### Validating genericode files

To validate one local genericode file, run batch file `validate-genericode-main` in folder `scripts` from the _root directory_ of the working tree of your local repository:

```bat
scripts\validate-genericode-main.bat C:\path\to\codelist.gc C:\path\to\output-directory
```

To validate all genericode files in a local directory, run batch file `validate-genericode-main` in folder `scripts` from the _root directory_ of the working tree of your local repository:

```bat
scripts\validate-genericode-main.bat C:\path\to\input-directory C:\path\to\output-directory
```

To validate one online genericode file, run batch file `validate-genericode-main` in folder `scripts` from the _root directory_ of the working tree of your local repository:

```bat
scripts\validate-genericode-main.bat https://example.org/codelist.gc C:\path\to\output-directory
```

Open the validation report(s) created in `C:\path\to\output-directory` in a browser.

Run the batch file without arguments to see all the options:

```bat
scripts\validate-genericode-main.bat
```

## Development

### Running the tests

The Schematron schemas are tested using [XSpec](https://github.com/xspec/xspec/), a unit test and behaviour-driven development (BDD) framework for XSLT, XQuery, and Schematron.

On Windows, the XSpec Schematron tests can be run using batch file `run-schematron-tests.bat` in the [scripts folder](/scripts). Run the batch file from the _root directory_ of the repository:

```bat
scripts\run-schematron-tests.bat
```

On Windows, the tests written in XProc can be run using batch file `run-xproc-tests.bat` in the [scripts folder](/scripts). Run the batch file from the _root directory_ of the repository:

```bat
scripts\run-xproc-tests.bat
```

### Creating the validation rules documentation

To create and publish the validation rules documentation:

1. Update both your local `main` and `gh-pages` branches so they match the corresponding branches in the central repository;
2. Create a new local branch, e.g. `doc`, that has branch `gh-pages` as start point and check that new branch out: `git checkout -b doc gh-pages`;
3. Merge branch `main` into the newly created branch: `git merge main`;
4. Run batch file `generate-docs.bat` from the _root directory_ of the repository: `scripts\generate-docs.bat`;
5. Commit the files in the `docs` folder and push your changes to your fork;
6. Create a pull request that is based on the central repository's `gh-pages` branch (⚠️ not on the `main` branch!).

## About the underlying standards and tools

### Genericode

[Genericode](https://docs.oasis-open.org/codelist/genericode/v1.0/genericode-v1.0.html), also known as Code List Representation, is “a single semantic model for code lists and accompanying XML serialization that is designed to IT-enable and standardize the publication of machine-readable code list information and its interchange between systems”[^1]. Genericode is developed by the [Organization for the Advancement of Structured Information Standards (OASIS)](https://www.oasis-open.org/). See the [website of the OASIS Code List Representation TC](https://www.oasis-open.org/committees/codelist/) for more information.

[^1]: Source: [Genericode Approved as an OASIS Standard](https://www.oasis-open.org/2023/02/01/genericode-approved-as-an-oasis-standard/)

### XProc

[Xproc](https://xproc.org/) is an XML based programming language for processing documents in pipelines. XProc 3 is developed by the [XProc Next Community Group](https://www.w3.org/community/xproc-next/), a community group of the [World Wide Web Consortium (W3C)](https://www.w3.org/).



