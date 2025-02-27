<?xml version="1.0" encoding="UTF-8"?>
<schema
    xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2"
	>
    
    <title>Additional rules for genericode files</title>
    <p>Additional rules for genericode files are specified by KDS.</p>

    <ns
        prefix="dcterms"
        uri="http://purl.org/dc/terms/" />
    <ns
        prefix="gc"
        uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" />
	<ns
        prefix="xs"
        uri="http://www.w3.org/2001/XMLSchema" />
		
	<let name="availableColumns" value="/*/ColumnSet/Column"/>
	<let name="countOfColumns" value="count($availableColumns)"/>

    <pattern id="document_type">
		<title>Genericode document type</title>
		<p>Rules for the genericode document type.</p>
		
		<rule context="/">
            <!-- Other types of Genericode Document Types are column set documents and code list set documents,
            see also https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html#S-GENERICODE-DOCUMENT-TYPES. -->
            <assert
                id="document_codelist"
                test="exists(gc:CodeList)">
				The document must be a code list document.
			</assert>
        </rule>
		
		<rule context="gc:CodeList">
			<assert 
				id="codelist_annotation_present"
				test="count(Annotation) eq 1">
				The gc:CodeList/annotation element must be present.
			</assert>
			<assert
                id="codelist_metadata_description_present"
                test="count(Annotation/Description) eq 1">
				Additional metadata for the code list must be present.
			</assert>
		</rule>
	</pattern>
	
	<pattern id="codelist_annotation">
		<title>Additional code list metadata</title>
		<p>Rules for additional code list metadata.</p>
		
		<rule context="gc:CodeList/Annotation/Description">
            <!-- In the genericode specification, the Annotation is documented as "User annotation information".
            Here this element is described as containg "additional metadata", as the Identification element
            is described as "Identification and location information (metadata)". -->
            <assert
                id="metadata_description_present"
                test="count(dcterms:description) eq 1">
				A description for the code list must be present.
			</assert>
			<assert
                id="metadata_provenance_present"
                test="count(dcterms:provenance) eq 1">
				Version history for the code list must be present.
			</assert>
			<assert
                id="metadata_language_present"
                test="count(dcterms:language) eq 1">
				The language of the code list must be present.
			</assert>
			<assert
                id="metadata_license_present"
                test="count(dcterms:license) eq 1">
				The license for the code list must be present.
			</assert>
        </rule>
		
		<rule context="gc:CodeList/Annotation/Description/dcterms:description">
			<assert 
				id="metadata_description_not_empty"
				test="normalize-space(.)!=''">
				The description for the code list must not be empty.
			</assert>
		</rule>
		
		<rule context="gc:CodeList/Annotation/Description/dcterms:provenance">
			<assert 
				id="metadata_provenance_not_empty"
				test="normalize-space(.)!=''">
				Version history for the code list must not be empty.
			</assert>
		</rule>
		
		<rule context="gc:CodeList/Annotation/Description/dcterms:language">
			<assert 
				id="metadata_language_not_empty"
				test="normalize-space(.) != ''">
				The language for the code list must not be empty.
			</assert>
		</rule>
		
		<rule context="gc:CodeList/Annotation/Description/dcterms:license">
			<assert 
				id="metadata_license_match_hyperlink"
				test="matches(.,'^(http(s)?://|(www\.)?)[a-zA-Z0-9@:%._\+~#=]{2,253}\.[a-z]{2,6}([-a-zA-Z0-9@:%_\+.~#?&amp;/=]{0,2048})$')"
				diagnostics="diag_node_value">
				The license must be provided as a hyperlink.
			</assert>
		</rule>
		
		<rule context="gc:CodeList/Annotation/Description/dcterms:source">
			<assert
				id="metadata_source_match_hyperlink"
				test=".='' or matches(.,'^(http(s)?://|(www\.)?)[a-zA-Z0-9@:%._\+~#=]{2,253}\.[a-z]{2,6}([-a-zA-Z0-9@:%_\+.~#?&amp;/=]{0,2048})$')"
				diagnostics="diag_node_value">
				When source is provided it must be a hyperlink.
			</assert>
		</rule>
		
	</pattern>
	
	<pattern id="identification">
		<title>Identification</title>
		<p>Rules for identification information.</p>
		
		<rule context="Version">
            <assert
                id="identification_version_match_semver"
                test="matches(.,'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$')"
                diagnostics="diag_node_value"
                see="https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string">
				The version must comply to the Semantic versioning specification.
			</assert>
        </rule>
		
		<rule context="Identification/ShortName">
			<assert 
				id="identification_shortname_not_empty" 
				test="normalize-space(.) != ''">
				ShortName must not be empty.
			</assert>
			<assert 
				id="identification_shortname_lower_case" 
				test=". = lower-case(.)" 
				diagnostics="diag_node_value">
				ShortName must only contain lowercase letters.
			</assert>
			<assert 
				id="identification_shortname_not_special_characters"
				test="matches(.,'^[a-z0-9_]*$','i')"
				diagnostics="diag_node_value">
				Special characters are not permitted in the ShortName field.
			</assert>
		</rule>
		
		<rule context="Identification/CanonicalUri">
			<assert 
				id="identification_canonicaluri_match_uuid"
				test="matches(., '^urn:uuid:[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$')"
				diagnostics="diag_node_value">
				CanonicalURI must be provided with a UUID.
			</assert>
		</rule>
		
		<rule context="Identification/CanonicalVersionUri">
			<assert 
				id="identification_canonicalversionuri_match_uuid"
				test="matches(., '^urn:uuid:[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$')"
				diagnostics="diag_node_value">
				CanonicalVersionURI must be provided with a UUID.
			</assert>
		</rule>
		
		<rule context="Identification/Agency/LongName">
			<assert 
				id="identification_longname_not_empty"
				test="normalize-space(.) !=''">
				The name of the owner of the code list must not be empty.
			</assert>
		</rule>
		
		<rule context="Identification">
			<let name="canonicalid" value="CanonicalUri"/>
			
			<assert 
				id="canonicaluri_and_canonicalversionuri_not_identical"
				test="$canonicalid != ./CanonicalVersionUri"
				diagnostics="diag_canonicaluri_equals_canonicalversionuri">
				The UUIDs associated with CanonicalURI and CanonicalVersionURI must not be identical.
			</assert>
			
			<assert
				id="identification_agency_longname_present"
				test="count(Agency/LongName) eq 1">
				The Agency/LongName element must be present in Identification.
			</assert>
			
			<assert 
				id="identification_agency_only_have_longname"
				test="count(Agency/*)=1"
				diagnostics="diag_agency_longname_not_only_child">
				The LongName field must be the only field under Agency.
			</assert>
		</rule>
		
	</pattern>
	
	<pattern id="columns">
		<title>Columns</title>
		<p>Rules for columns.</p>
		
		<rule context="ColumnSet/Column">
			<let name="id" value="./@Id" />
			<let name="shortname" value="./ShortName" />
			<assert
				id="column_id_equals_column_shortname"
				test="$id eq $shortname"
				diagnostics="diag_column_id_not_equal_shortname">
				The value of Column/@Id and Column/ShortName must be identical.
			</assert>
		</rule>
		
	</pattern>
	
	<pattern id="values">
		<title>Values</title>
		<p>Rules for values.</p>
		
		<rule context="Row/Value[@ColumnRef = 'kode']/SimpleValue">
			<assert
				id="row_code_simplevalue_separators"
				test="not(matches(., '[\p{Z}-[&#x20;]]'))"
				diagnostics="diag_node_value">
				A code must not contain separators that are not spaces.
			</assert>
			<assert 
				id="row_code_simplevalue_consecutive_spaces"
				test="not(matches(., '&#x20;&#x20;'))"
				diagnostics="diag_node_value">
				A code must not contain two consecutive spaces.
			</assert>
			<assert
				id="row_code_simplevalue_control_character"
				test="not(matches(., '[\p{Cc}]'))"
				diagnostics="diag_node_value">
				A code must not contain control characters.
			</assert>
			<assert
				id="row_code_simplevalue_leading_space"
				test="not(matches(., '^&#x20;'))"
				diagnostics="diag_node_value">
				A code must not start with space.
			</assert>
			<assert
				id="row_code_simplevalue_ending_space"
				test="not(matches(., '&#x20;$'))"
				diagnostics="diag_node_value">
				A code must not end with space.
			</assert>
			<report
				id="row_code_simplevalue_report_starting_character"
				test="not(matches(., '^[a-zA-Z0-9æøåéÆØÅÉ&#x3C;&#x3E;=]'))"
				role="warning"
				diagnostics="diag_node_value">
				A code is found to begin with a character that is not in the recommended set [a-zA-Z0-9æøåéÆØÅÉ=&#x3C;&#x3E;].
			</report>
			<report
				id="row_code_simplevalue_report_ending_character"
				test="not(matches(., '[a-zA-Z0-9æøåéÆØÅÉ)-]$'))"
				role="warning"
				diagnostics="diag_node_value">
				A code is found to end with a character that is not in the recommended set [a-zA-Z0-9æøåéÆØÅÉ)-].
			</report>
			<report
				id="row_code_simplevalue_report_symbol"
				test="not(matches(., '^[a-zA-Z0-9æøåéÆØÅÉ_,.&#x3C;&#x3E;&#x20;&#x26;Ωαβ/():+=''§%-]+$'))"
				role="warning"
				diagnostics="diag_node_value">
				A code was found to contain discouraged characters. Recommended characters include: digits (0-9), lower and uppercase letters (a-z, æ, ø, å, é), Greek letters (Ω, α, β), mathematical symbols (+, &#x3C;, &#x3E;, =), punctuation marks (-_()%&#x26;',./:§) and spaces.
			</report>
		</rule>
		
		<rule context="Row/Value[@ColumnRef='virkningFra']/SimpleValue">
			<!-- without YYYY check, a date of 20251284-02-15 would also be accepted as a castable xs:date and no error is raised -->
			<let name="YYYYtrue" value="matches(., '^\d{4}-')" />
			<assert 
				id="row_virkningfra_format_as_date"
				test=". castable as xs:date and $YYYYtrue"
				diagnostics="diag_node_value">
				virkningFra must be a valid date in the format YYYY-MM-DD.
			</assert>
			
			<assert
				id="row_virkningfra_not_empty"
				test="normalize-space(.) != ''">
				The field virkningFra must not be empty.
			</assert>
		</rule>
		
		<rule context="Row/Value[@ColumnRef='virkningTil']/SimpleValue[text() != '']">
		
			<let name="virkfraVal" value="./../preceding-sibling::Value[@ColumnRef='virkningFra']/SimpleValue" />
			<let name="YYYYtrue" value="matches(., '^\d{4}-')" />
			<assert 
				id="row_virkningtil_format_as_date"
				test=". castable as xs:date and $YYYYtrue"
				diagnostics="diag_node_value">
				When provided, virkningTil must be a valid date in the format YYYY-MM-DD.
			</assert>
			
			<assert
				id="row_virkningtil_date_after_virkningfra"
				test="$virkfraVal le ."
				diagnostics="diag_row_virkningtil_not_date_after_virkningfra">
				The date specified for virkningTil must be the same as or later than the date specified for virkningFra.
			</assert>
		</rule>
		
		<rule context="SimpleCodeList/Row">
			<let name="rowvaluecount" value="count(Value)" />
			<assert 
				id="row_value_count_equals_column_count"
				test="$rowvaluecount eq $countOfColumns"
				diagnostics="diag_row_value_count">
				The number of row values must equal the number of declared columns.
			</assert>
			
			<let name="columnRefs" value="Value/@ColumnRef" />
			<assert
                id="row_value_order_equals_column_order"
                test="deep-equal(for $columnRef in $columnRefs return string($columnRef),for $id in $availableColumns/@Id return string($id))"
                diagnostics="diag_column_ids diag_column_refs">
				The number and order of the values in a row must be the same as the number and order of the columns.
			</assert>
		</rule>
	</pattern>

    <diagnostics>
        <diagnostic id="diag_node_value">
            <value-of select="'Value in ' || name(.) || ': ' || ." />
        </diagnostic>
		<diagnostic id="diag_row_value_count">
			Number of row values: <value-of select="$rowvaluecount" />
			Number of columns: <value-of select="$countOfColumns" />
		</diagnostic>
		<diagnostic id="diag_row_virkningtil_not_date_after_virkningfra">
			<value-of select="$virkfraVal/../@ColumnRef" />: <value-of select="$virkfraVal"/> 
			<value-of select="./../@ColumnRef" />: <value-of select="."/>
		</diagnostic>
		<diagnostic id="diag_canonicaluri_equals_canonicalversionuri">
			Value of CanonicalUri and CanonicalVersionUri: <value-of select="$canonicalid" />
		</diagnostic>
		<diagnostic id="diag_agency_longname_not_only_child">
			Expected only LongName but found: <value-of select="string-join(for $a in Agency/* return name($a), ', ')" />
		</diagnostic>
		<diagnostic id="diag_column_id_not_equal_shortname">
			Column/Id: <value-of select="$id"/>; Column/ShortName: <value-of select="$shortname" />
		</diagnostic>
		<diagnostic id="diag_column_ids">
            Ids of declared columns: <value-of select="string-join($availableColumns/@Id, ', ')" />
        </diagnostic>
        <diagnostic id="diag_column_refs">
            Column references in row: <value-of select="string-join($columnRefs, ', ')" />
        </diagnostic>
    </diagnostics>

</schema>