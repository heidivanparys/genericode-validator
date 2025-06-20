<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is based on
    https://github.com/xproc/xvrl-tools/blob/24f2f9f944ff7ac06724bd6ace00b4e9f0204f28/xsl/svrl2xvrl.xsl
	licensed under the Apache License, Version 2.0
	A copy of the Apache License can be obtained at http://www.apache.org/licenses/LICENSE-2.0

	Modifications are licensed under the MIT License.
	A copy of the MIT License can be obtained at https://opensource.org/licenses/MIT
-->
<xsl:stylesheet
    xmlns="http://www.xproc.org/ns/xvrl"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    version="3.0"
    exclude-result-prefixes="#all">

    <xsl:param
        name="schema-uri"
        as="xsd:anyURI"
        required="true" />

    <xsl:param
        name="default-severity"
        as="xsd:string"
        select="'error'" />
        
    <xsl:mode on-no-match="text-only-copy" />

    <xsl:template match="svrl:schematron-output">
        <report>
            <metadata>
                <!-- If the report has been created with SchXslt, find timestamp and validator in the locations specified below -->
                <xsl:if test="exists(svrl:metadata/dcterms:created)">
                    <timestamp>
                        <xsl:value-of select="svrl:metadata/dcterms:created" />
                    </timestamp>
                </xsl:if>
                <xsl:if test="exists(svrl:metadata/dcterms:source/rdf:Description/dcterms:creator/dcterms:Agent/skos:prefLabel)">
                    <validator>
                        <xsl:attribute
                            name="name"
                            select="svrl:metadata/dcterms:source/rdf:Description/dcterms:creator/dcterms:Agent/skos:prefLabel" />
                    </validator>
                </xsl:if>
                <xsl:if test="exists(@title)">
                    <!-- Add title if the Schematron schema has a title and the Schematron processor adds that title to the SVRL report -->
                    <title>
                        <xsl:value-of select="@title" />
                    </title>
                </xsl:if>
                <xsl:if test="exists(svrl:text)">
                    <!-- Assumption: the first p element in a Schematron schema, if present, contains a short description of the schema. -->
                    <summary>
                        <xsl:value-of select="svrl:text[1]" />
                    </summary>
                </xsl:if>
                <schema schematypens="http://purl.oclc.org/dsdl/schematron">
                    <xsl:attribute
                        name="href"
                        select="$schema-uri" />
                </schema>
                    </metadata>
            <digest>
                <!-- See e.g. https://github.com/xspec/xspec/wiki/Writing-Scenarios-for-Schematron#xexpect-
                for common practices regarding the use of the role attribute in SVRL reports. -->
                <xsl:variable
                    name="noOfDetectionsWithoutExplicitSeverity"
                    select="count(svrl:failed-assert[not(exists(@role))]) + count(svrl:successful-report[not(exists(@role))])" />
                <xsl:variable
                    name="noOfDetectionsExplicitFatalError"
                    select="count(svrl:failed-assert[lower-case(@role) eq 'fatal-error']) + count(svrl:successful-report[lower-case(@role) eq 'fatal-error'])" />
                <xsl:variable
                    name="noOfDetectionsExplicitError"
                    select="count(svrl:failed-assert[lower-case(@role) eq 'error']) + count(svrl:successful-report[lower-case(@role) eq 'error'])" />
                <xsl:variable
                    name="noOfDetectionsExplicitWarning"
                    select="count(svrl:failed-assert[lower-case(@role) eq 'warning']) + count(svrl:successful-report[lower-case(@role) eq 'warning']) + count(svrl:failed-assert[lower-case(@role) eq 'warn']) + count(svrl:successful-report[lower-case(@role) eq 'warn'])" />
                <xsl:variable
                    name="noOfDetectionsExplicitInfo"
                    select="count(svrl:failed-assert[lower-case(@role) eq 'info']) + count(svrl:successful-report[lower-case(@role) eq 'info'])" />
                    
                <xsl:variable
                    name="noOfDetectionsFatalError"
                    select="if (lower-case($default-severity) eq 'fatal-error') then ($noOfDetectionsWithoutExplicitSeverity + $noOfDetectionsExplicitFatalError) else ($noOfDetectionsExplicitFatalError)" />
                <xsl:variable
                    name="noOfDetectionsError"
                    select="if (lower-case($default-severity) eq 'error') then ($noOfDetectionsWithoutExplicitSeverity + $noOfDetectionsExplicitError) else ($noOfDetectionsExplicitError)" />
                <xsl:variable
                    name="noOfDetectionsWarning"
                    select="if (lower-case($default-severity) eq 'warning' or lower-case($default-severity) eq 'warn') then ($noOfDetectionsWithoutExplicitSeverity + $noOfDetectionsExplicitWarning) else ($noOfDetectionsExplicitWarning)" />
                <xsl:variable
                    name="noOfDetectionsInfo"
                    select="if (lower-case($default-severity) eq 'info' or lower-case($default-severity) eq 'information') then ($noOfDetectionsWithoutExplicitSeverity + $noOfDetectionsExplicitInfo) else ($noOfDetectionsExplicitInfo)" />
                    
                <xsl:attribute
                    name="fatal-error-count"
                    select="$noOfDetectionsFatalError" />
                <xsl:attribute
                    name="error-count"
                    select="$noOfDetectionsError" />
                <xsl:attribute
                    name="warning-count"
                    select="$noOfDetectionsWarning" />
                <xsl:attribute
                    name="info-count"
                    select="$noOfDetectionsInfo" />
                <xsl:attribute
                    name="valid"
                    select="if (($noOfDetectionsFatalError + $noOfDetectionsError) eq 0) then true() else false()" />
            </digest>
            
            <!-- No changes made to the rest of this template in comparison to 
            https://github.com/xproc/xvrl-tools/blob/24f2f9f944ff7ac06724bd6ace00b4e9f0204f28/xsl/svrl2xvrl.xsl -->
            <xsl:for-each-group
                select="*"
                group-starting-with="svrl:active-pattern">
                <xsl:if test="exists(current-group()[1]/self::svrl:active-pattern)">
                    <xsl:variable
                        name="pattern"
                        as="element(svrl:active-pattern)"
                        select="." />
                    <xsl:for-each-group
                        select="current-group()[position() gt 1]"
                        group-starting-with="svrl:fired-rule">
                        <xsl:apply-templates select="current-group()/(self::svrl:successful-report | self::svrl:failed-assert)">
                            <xsl:with-param
                                name="rule"
                                tunnel="yes"
                                as="element(svrl:fired-rule)"
                                select="." />
                            <xsl:with-param
                                name="pattern"
                                tunnel="yes"
                                as="element(svrl:active-pattern)"
                                select="$pattern" />
                        </xsl:apply-templates>
                    </xsl:for-each-group>
                </xsl:if>
            </xsl:for-each-group>
        </report>
    </xsl:template>

    <xsl:template match="svrl:failed-assert|svrl:successful-report">
        <xsl:param
            name="rule"
            as="element(svrl:fired-rule)"
            tunnel="yes" />
        <detection>
            <xsl:attribute
                name="severity"
                select="$default-severity" />
            <xsl:apply-templates select="@role" />
            <location>
                <xsl:attribute
                    name="xpath"
                    select="@location" />
            </location>
            <!-- The name of the pattern defining the assert/report is used as category. -->
            <xsl:if test="exists(preceding-sibling::svrl:active-pattern[1]/@name)">
                <category>
                    <xsl:value-of select="preceding-sibling::svrl:active-pattern[1]/@name" />
                </category>
            </xsl:if>
            <xsl:apply-templates select="$rule/@context" />
            <xsl:apply-templates select="svrl:text" />
            <xsl:apply-templates select="svrl:diagnostic-reference" />
        </detection>
    </xsl:template>

    <xsl:template match="@role">
        <xsl:attribute
            name="severity"
            select="." />
    </xsl:template>

    <xsl:template match="@context">
        <context>
            <location xpath="{.}" />
        </context>
    </xsl:template>

    <!-- The text in the assert/report element in the Schematron document is placed in a message element,
    see also https://github.com/xproc/xvrl/issues/9 -->
    <xsl:template match="(svrl:failed-assert|svrl:successful-report)/svrl:text">
        <message>
            <xsl:apply-templates select="(@xml:lang, ../@xml:lang)[1], node()" />
        </message>
    </xsl:template>
    
    <!-- The text in a diagnostic element is placed in a supplemental element,
    see also https://github.com/xproc/xvrl/issues/9 -->
    <xsl:template match="(svrl:failed-assert|svrl:successful-report)/svrl:diagnostic-reference">
        <supplemental>
            <xsl:apply-templates select="(@xml:lang, ../@xml:lang)[1], node()" />
        </supplemental>
    </xsl:template>

    <xsl:template match="@xml:lang">
        <xsl:copy />
    </xsl:template>

</xsl:stylesheet>