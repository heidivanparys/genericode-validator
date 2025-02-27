<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:variable
        name="organisation"
        select="'Agency for Climate Data'" />

    <xsl:variable
        name="designsystemVersion"
        select="'8'" />

    <xsl:variable
        name="designsystemUrl"
        select="'https://cdn.dataforsyningen.dk/assets/designsystem/v' || $designsystemVersion" />
        
    <xsl:template name="addId">
        <xsl:if test="exists(@id)">
            <xsl:attribute
                name="id"
                select="@id" />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>