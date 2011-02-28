<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="substringBefore">
		<xsl:param name="the_string" />
		<xsl:param name="to_remove" />
		<xsl:value-of select="substring-before($the_string,$to_remove)" />;
	</xsl:template>
				  

	
</xsl:stylesheet>
