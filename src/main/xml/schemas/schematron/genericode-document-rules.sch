<?xml version="1.0" encoding="UTF-8"?>
<!--
  This is a set of extra-schema document rules, implemented in Schematron, for OASIS genericode files
  as described in the conformance section 4.2 of the genericode specification [genericode 1.0].

  This set of Schematron rules is a derivative work that is an alternative implementation of the 
  document-related auxiliary rules specified in the file available at:
  https://docs.oasis-open.org/codelist/genericode/v1.0/os/sch/genericode.sch.
  
  [genericode-1.0] Code List Representation (genericode) Version 1.0. Edited by G. Ken Holman. 
  31 January 2023. OASIS Standard. https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html. 
  Latest stage: https://docs.oasis-open.org/codelist/genericode/v1.0/genericode-v1.0.html.

  Copyright © OASIS Open 2021-2024. All Rights Reserved.
  This derivative work is provided under the terms of the OASIS IPR Policy, available at:
  https://www.oasis-open.org/policies-guidelines/ipr/.
  
  This work is provided "AS IS", without warranties of any kind, and OASIS disclaims any and all liability for its use.
-->
<schema
    xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2">

    <title>Document rules for genericode files</title>
    <p>The document rules for genericode files are specified in the genericode specification.</p>

    <ns
        prefix="gc"
        uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" />

    <let
        name="availableColumns"
        value="/*/ColumnSet/Column" />
    <let
        name="requiredColumns"
        value="$availableColumns[@Use='required']" />

    <pattern>
        <rule context="SimpleCodeList">
            <assert
                id="rule_1"
                test="count(/*/ColumnSet/Key)>0">Rule 1 - A code list must have at least one key, unless it is a metadata-only definition without a SimpleCodeList element.
            </assert>
        </rule>
        <!-- Split the original rule in into two rules
        to allow for more clear messages ("What must be an absolute URI?"). -->
        <rule context="CanonicalUri">
            <assert
                id="rules_4_25_30_48"
                test="matches(.,'^\w+:')"
                diagnostics="diag_node_value">Rules 4, 25, 30, 48 - A canonical URI must be an absolute URI, it must not be relative.</assert>
        </rule>
        <rule context="CanonicalVersionUri">
            <assert
                id="rules_6_27_32_44_50"
                test="matches(.,'^\w+:')"
                diagnostics="diag_node_value">Rules 6, 27, 32, 44, 50 - A canonical version URI must be an absolute URI, it must not be relative.</assert>
        </rule>
        <!-- Change the context and the test in comparison to the original rule, to allow for reusing the diagnostic. -->
        <rule context="Data/@Type">
            <assert
                id="rule_19"
                test="not(contains(.,':'))"
                diagnostics="diag_node_value">Rule 19 - A datatype ID must not include a namespace prefix.</assert>
        </rule>
        <rule context="@ExternalRef">
            <assert
                id="rule_24"
                test="not(starts-with(.,'#'))"
                diagnostics="diag_node_value">Rule 24 - The external reference must not be prefixed with a '#' symbol.</assert>
        </rule>
        <!-- Rephrased the original so it does not use "can". See also the Basic RuleSpeak Guidelines and the RuleSpeak sentence forms.  -->
        <rule context="Key">
            <assert
                id="rule_34"
                test="exists($requiredColumns[@Id=current()/ColumnRef/@Ref])">Rule 34 - A key may reference a column only if that column is required.</assert>
        </rule>
        <rule context="ShortName">
            <assert
                id="rule_39"
                test="not(matches(.,'\s'))"
                diagnostics="diag_node_value">Rule 39 - A short name must not contain whitespace characters.</assert>
        </rule>
        <rule context="ComplexValue">
            <assert
                id="rule_42"
                test="every $name in */local-name(.) satisfies
                    for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@Type)=
                    ('*',$name)"
                diagnostics="diag_data_types">
                Rule 42 - The names of all direct child elements of the 'ComplexValue' element must match the datatype ID for the matching column, unless
                that ID is set to '*'.
            </assert>
            <assert
                id="rule_43"
                test="every $uri in */namespace-uri(.)[normalize-space(.)] satisfies
                    for $id in ancestor::Value[1]/@ColumnRef return
         normalize-space($availableColumns[@Id=$id][1]/Data/@DatatypeLibrary)=
         ('*',$uri)"
                diagnostics="diag_datatype_library">
                Rule 43 - The namespace URIs of all direct child elements of the 'ComplexValue' element must match the datatype library URI for the
                matching column, unless that URI is set to '*'.
            </assert>
        </rule>
        <rule context="Row">
            <!-- The test has been changed in comparision to the original rule. From the standard:
            "A required column does not allow any row to have an undefined (nil or null) value."
            and
            "If a Value element does not contain either a SimpleValue element or a ComplexValue element, then the value is undefined.
            Only optional columns are allowed to have undefined values."
            That means that an empty Value element referencing a required column should fail the assert too.
            The ColumnRef attribute of a Value is actually optional. The assert does not take that possibility into account.
            -->
            <let name="columnRefs" value="Value/@ColumnRef" />
            <assert
                id="rule_37"
                test="not(some $id in $requiredColumns/@Id satisfies not($id = $columnRefs)) and not(some $id in $requiredColumns/@Id satisfies not(exists(Value[@ColumnRef eq $id]/SimpleValue)))"
                diagnostics="diag_required_columns diag_missing_required_column_references diag_empty_values">
                Rule 37 - A value must be provided for each required column.
            </assert>

            <!--Miscellaneous integrity rules-->
            <!--any column can have only one definition in a given row-->
            <assert
                id="one_value_per_column"
                test="not(some $ref in Value/@ColumnRef satisfies $ref = ( Value except $ref/.. )/@ColumnRef)"
                diagnostics="diag_duplicate_columns_in_row">
                Unnumbered rule - A row must not contain more than one value for the same column.
            </assert>

        </rule>
    </pattern>

    <diagnostics>
        <diagnostic id="diag_node_value">
            <value-of select="'Value in ' || name(.) || ': ' || ." />
        </diagnostic>
        <diagnostic id="diag_required_columns">
            Ids of required columns:
            <value-of select="string-join($requiredColumns/@Id, ', ')" />
        </diagnostic>
        <diagnostic id="diag_data_types">
            Expected: 
            <value-of
                select='for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@Type)' />
        </diagnostic>
        <diagnostic id="diag_datatype_library">
            Expected: 
            <value-of
                    select='for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@DatatypeLibrary)' />
        </diagnostic>
        <diagnostic id="diag_missing_required_column_references">
            <value-of
                select="let $missingRequiredColumnIds := $requiredColumns/@Id[not(. = $columnRefs)]
            return
              if (exists($missingRequiredColumnIds))
              then 'Missing values for required column references: ' || (string-join($missingRequiredColumnIds, ', '))
              else 'No missing required column references'" />
        </diagnostic>
        <diagnostic id="diag_empty_values">
            <value-of
                select="let $columnReferencesEmptyValues := Value[@ColumnRef = $requiredColumns/@Id and not(exists(SimpleValue))]/@ColumnRef
            return
              if (exists($columnReferencesEmptyValues))
              then 'The following Value elements reference a required column but have no content: ' || string-join($columnReferencesEmptyValues, ', ')
              else 'No empty Value elements'" />
        </diagnostic>
        <diagnostic id="diag_duplicate_columns_in_row">
            More than one value is given for the following columns:
            <value-of
                select="let $dups := for $dup in distinct-values(Value/@ColumnRef/string(.)) return
                  if (count(Value/@ColumnRef[. = $dup]) gt 1)
                  then $dup else ()
                  return string-join($dups, ', ')" />
        </diagnostic>
    </diagnostics>

</schema>