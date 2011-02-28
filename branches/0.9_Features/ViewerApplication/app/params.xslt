<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="external_urn_resolver">disabled</xsl:variable>
	
	<xsl:variable name="urn_resource_file">ie/urn_resource_map.xml</xsl:variable>
	
	<xsl:variable name="external_resource_url_prefix"/>
	
	<xsl:variable name="document_resource_url_prefix"/>
	<!-- Default state of metadata pane. Note: possible values are 'none' and 'display' -->
	<xsl:variable name="metadataPaneState">none</xsl:variable>
	<!-- Image specific variable in which controls the layout and format -->
	<xsl:variable name="showFigures">false</xsl:variable>
	<xsl:variable name="enableAltImgFormat">false</xsl:variable>
	<!--
		The pattern have following syntax
		orginalFormat|alternativeFormat
		in where the | separate original and alternative. The pattern may have serveral
		original and respective alternative format defined. If there exists more than one
		then it must be separated by a ' ' (white space).
	-->
	<xsl:variable name="altCgmFormat">cgm|png</xsl:variable>
	<!-- Set size of table border of lists. This variable is just for debug purpose only -->
	<xsl:variable name="listBorder">0</xsl:variable>
	<!-- 
		Generated text
		The valid language in dm is defined by attribute "language" off dmodule element.
		Follwing langage code are valid defined in dtd:
		us,ue,sv and fr.

	-->
	<!-- dmodule language -->
	<xsl:variable name="language" select="dmodule/@language"/>
	
	<xsl:variable name="manfac">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Manufacturer</xsl:with-param>
			<xsl:with-param name="sv">Manufacturer</xsl:with-param>
			<xsl:with-param name="fr">Manufacturer</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="part_nr">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Part number</xsl:with-param>
			<xsl:with-param name="sv">Part number</xsl:with-param>
			<xsl:with-param name="fr">Part number</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rpc">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Responsible Partner Company</xsl:with-param>
			<xsl:with-param name="sv">Responsible Partner Company</xsl:with-param>
			<xsl:with-param name="fr">Responsible Partner Company</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="condition">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Condition</xsl:with-param>
			<xsl:with-param name="sv">Condition</xsl:with-param>
			<xsl:with-param name="fr">Condition</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="serialnr">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Serial number</xsl:with-param>
			<xsl:with-param name="sv">Serial number</xsl:with-param>
			<xsl:with-param name="fr">Serial number</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="ref_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">References</xsl:with-param>
			<xsl:with-param name="sv">Referenser</xsl:with-param>
			<xsl:with-param name="fr">Références</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="reference">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Reference</xsl:with-param>
			<xsl:with-param name="sv">Referense</xsl:with-param>
			<xsl:with-param name="fr">Référence</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="pre_req_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Preleminary requirements</xsl:with-param>
			<xsl:with-param name="sv">Förbredelser</xsl:with-param>
			<xsl:with-param name="fr">Exigences préliminaires</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="applic_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Applicability</xsl:with-param>
			<xsl:with-param name="sv">Giltighet</xsl:with-param>
			<xsl:with-param name="fr">Applicability</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="req_con_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Required conditions</xsl:with-param>
			<xsl:with-param name="sv">Förebyggande åtg</xsl:with-param>
			<xsl:with-param name="fr">Conditions préparatoires</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="close_con_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Close-up conditions</xsl:with-param>
			<xsl:with-param name="sv">Avslutande åtg</xsl:with-param>
			<xsl:with-param name="fr">Conditions finalment</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="sup_equ_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Support equipment</xsl:with-param>
			<xsl:with-param name="sv">Hjälputrustning</xsl:with-param>
			<xsl:with-param name="fr">Équipement d&apos;appui</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="consumables_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Consumables</xsl:with-param>
			<xsl:with-param name="sv">Förbrukningsmaterial</xsl:with-param>
			<xsl:with-param name="fr">Objects de consommation</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="spares_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Spares</xsl:with-param>
			<xsl:with-param name="sv">Reservdelar</xsl:with-param>
			<xsl:with-param name="fr">Rechanges</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="equip_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Equipment</xsl:with-param>
			<xsl:with-param name="sv">Equipment</xsl:with-param>
			<xsl:with-param name="fr">Equipment</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="saf_con_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Safety conditions</xsl:with-param>
			<xsl:with-param name="sv">Säkerhetskrav</xsl:with-param>
			<xsl:with-param name="fr">Exigences de sécurité</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="crew_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Crew</xsl:with-param>
			<xsl:with-param name="sv">Besättning</xsl:with-param>
			<xsl:with-param name="fr">Procédure</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="procedure_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Procedure</xsl:with-param>
			<xsl:with-param name="sv">Förfarande</xsl:with-param>
			<xsl:with-param name="fr">Procédure</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="req_job_com_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Requirements after job completion</xsl:with-param>
			<xsl:with-param name="sv">Avslutande åtgärder</xsl:with-param>
			<xsl:with-param name="fr">Exigences après achèvement du travial</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="fau_iso_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Fault Isolation</xsl:with-param>
			<xsl:with-param name="sv">Felsökning</xsl:with-param>
			<xsl:with-param name="fr">Localisation d&apos;erreur</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="fau_des_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Fault Description</xsl:with-param>
			<xsl:with-param name="sv">Felbeskrivning</xsl:with-param>
			<xsl:with-param name="fr">Description d&apos;erreur</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="fau_cod_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Fault Code</xsl:with-param>
			<xsl:with-param name="sv">Felkod</xsl:with-param>
			<xsl:with-param name="fr">Code d&apos;erreur</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="fau_con_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Fault Context</xsl:with-param>
			<xsl:with-param name="sv">Felmiljö</xsl:with-param>
			<xsl:with-param name="fr">Contexte de d&apos;efaut</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="fau_det_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Detection Information</xsl:with-param>
			<xsl:with-param name="sv">Spårinformation</xsl:with-param>
			<xsl:with-param name="fr">L&#39;information de d&apos;etection</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="name_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Name</xsl:with-param>
			<xsl:with-param name="sv">Namn</xsl:with-param>
			<xsl:with-param name="fr">Nom</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="id_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">ID</xsl:with-param>
			<xsl:with-param name="sv">Identifikation (ID)</xsl:with-param>
			<xsl:with-param name="fr">ID</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="qty_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Qty</xsl:with-param>
			<xsl:with-param name="sv">Antal</xsl:with-param>
			<xsl:with-param name="fr">Qté</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="remarks_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Remarks</xsl:with-param>
			<xsl:with-param name="sv">Anteckn</xsl:with-param>
			<xsl:with-param name="fr">Notes</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="add_info_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Additional Info</xsl:with-param>
			<xsl:with-param name="sv">Tilläggsinformation</xsl:with-param>
			<xsl:with-param name="fr">Information supplémentaire</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="ref_id_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Reference ID</xsl:with-param>
			<xsl:with-param name="sv">Referenser</xsl:with-param>
			<xsl:with-param name="fr">ID référence</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="question_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Question</xsl:with-param>
			<xsl:with-param name="sv">Frågor</xsl:with-param>
			<xsl:with-param name="fr">Question</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="answer_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Answer</xsl:with-param>
			<xsl:with-param name="sv">Svar</xsl:with-param>
			<xsl:with-param name="fr">Réponse</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="caution_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">CAUTION</xsl:with-param>
			<xsl:with-param name="sv">Observera</xsl:with-param>
			<xsl:with-param name="fr">Attention</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="note_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Note</xsl:with-param>
			<xsl:with-param name="sv">Anmärkning</xsl:with-param>
			<xsl:with-param name="fr">Note</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="warning_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">WARNING</xsl:with-param>
			<xsl:with-param name="sv">VARNING</xsl:with-param>
			<xsl:with-param name="fr">Avertissement</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="danger_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Danger</xsl:with-param>
			<xsl:with-param name="sv">Livsfara</xsl:with-param>
			<xsl:with-param name="fr">Danger</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="figure_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Figure</xsl:with-param>
			<xsl:with-param name="sv">Bild</xsl:with-param>
			<xsl:with-param name="fr">Figure</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="table_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Table</xsl:with-param>
			<xsl:with-param name="sv">Tabell</xsl:with-param>
			<xsl:with-param name="fr">Table</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="key_fig_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Key to Fig.</xsl:with-param>
			<xsl:with-param name="sv">Pos till Bild.</xsl:with-param>
			<xsl:with-param name="fr">Légende de figure</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="conditional_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Conditional</xsl:with-param>
			<xsl:with-param name="sv">Förutsättningar</xsl:with-param>
			<xsl:with-param name="fr">Conditionelle</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="close_up_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Close-up</xsl:with-param>
			<xsl:with-param name="sv">Avslutande åtg.</xsl:with-param>
			<xsl:with-param name="fr">Mesures finales</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="none_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">None</xsl:with-param>
			<xsl:with-param name="sv">Inga</xsl:with-param>
			<xsl:with-param name="fr">Rien</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="person_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Person</xsl:with-param>
			<xsl:with-param name="sv">Person</xsl:with-param>
			<xsl:with-param name="fr">Person</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="skill_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Skill</xsl:with-param>
			<xsl:with-param name="sv">Skill</xsl:with-param>
			<xsl:with-param name="fr">Skill</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="level_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Level</xsl:with-param>
			<xsl:with-param name="sv">Level</xsl:with-param>
			<xsl:with-param name="fr">Level</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="mark_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Mark</xsl:with-param>
			<xsl:with-param name="sv">Mark</xsl:with-param>
			<xsl:with-param name="fr">Mark</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="change_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Change</xsl:with-param>
			<xsl:with-param name="sv">Change</xsl:with-param>
			<xsl:with-param name="fr">Change</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="req_person_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Required person</xsl:with-param>
			<xsl:with-param name="sv">Required person</xsl:with-param>
			<xsl:with-param name="fr">Required person</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="cat_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Category</xsl:with-param>
			<xsl:with-param name="sv">Category</xsl:with-param>
			<xsl:with-param name="fr">Category</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="trade_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Trade</xsl:with-param>
			<xsl:with-param name="sv">Trade</xsl:with-param>
			<xsl:with-param name="fr">Trade</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="esttime_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Estimate time</xsl:with-param>
			<xsl:with-param name="sv">Estimate time</xsl:with-param>
			<xsl:with-param name="fr">Estimate time</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<!-- schedule part-->
	<xsl:variable name="task_def_title">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Task Definitions</xsl:with-param>
			<xsl:with-param name="sv">Task Definitions</xsl:with-param>
			<xsl:with-param name="fr">Task Definitions</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="timlim_title">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Time limit</xsl:with-param>
			<xsl:with-param name="sv">Time limit</xsl:with-param>
			<xsl:with-param name="fr">Time limit</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="reduced_maintaince">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Reduced maintaince</xsl:with-param>
			<xsl:with-param name="sv">Reduced maintaince</xsl:with-param>
			<xsl:with-param name="fr">Reduced maintaince</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="req_skill_lev">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Required skill level</xsl:with-param>
			<xsl:with-param name="sv">Required skill level</xsl:with-param>
			<xsl:with-param name="fr">Required skill level</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="timlim_type">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Time limit type</xsl:with-param>
			<xsl:with-param name="sv">Time limit type</xsl:with-param>
			<xsl:with-param name="fr">Time limit type</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="def_title">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Definition</xsl:with-param>
			<xsl:with-param name="sv">Definition</xsl:with-param>
			<xsl:with-param name="fr">Definition</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="definspec_title">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Inspection definitions</xsl:with-param>
			<xsl:with-param name="sv">Inspection definitions</xsl:with-param>
			<xsl:with-param name="fr">Inspection definitions</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="tasklst_title">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Task list</xsl:with-param>
			<xsl:with-param name="sv">Task list</xsl:with-param>
			<xsl:with-param name="fr">Task list</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="limit_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Limits</xsl:with-param>
			<xsl:with-param name="sv">Limits</xsl:with-param>
			<xsl:with-param name="fr">Limits</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="condition_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Condition</xsl:with-param>
			<xsl:with-param name="sv">Condition</xsl:with-param>
			<xsl:with-param name="fr">Condition</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="typex_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Type</xsl:with-param>
			<xsl:with-param name="sv">Type</xsl:with-param>
			<xsl:with-param name="fr">Type</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="thres_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Threshold</xsl:with-param>
			<xsl:with-param name="sv">Threshold</xsl:with-param>
			<xsl:with-param name="fr">Threshold</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="uom">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Unit of measure</xsl:with-param>
			<xsl:with-param name="sv">Unit of measure</xsl:with-param>
			<xsl:with-param name="fr">Unit of measure</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="inspec_type">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Inspection type</xsl:with-param>
			<xsl:with-param name="sv">Inspection type</xsl:with-param>
			<xsl:with-param name="fr">Inspection type</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="value_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Value</xsl:with-param>
			<xsl:with-param name="sv">Value</xsl:with-param>
			<xsl:with-param name="fr">Value</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="tolerance_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Tolerance</xsl:with-param>
			<xsl:with-param name="sv">Tolerance</xsl:with-param>
			<xsl:with-param name="fr">Tolerance</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="refinspec_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Inspection type</xsl:with-param>
			<xsl:with-param name="sv">Inspection type</xsl:with-param>
			<xsl:with-param name="fr">Inspection type</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="lim_range_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Limit range</xsl:with-param>
			<xsl:with-param name="sv">Limit range</xsl:with-param>
			<xsl:with-param name="fr">Limit range</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="from_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">from</xsl:with-param>
			<xsl:with-param name="sv">from</xsl:with-param>
			<xsl:with-param name="fr">from</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="to_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">to</xsl:with-param>
			<xsl:with-param name="sv">to</xsl:with-param>
			<xsl:with-param name="fr">to</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="trigger_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Trigger</xsl:with-param>
			<xsl:with-param name="sv">trigger</xsl:with-param>
			<xsl:with-param name="fr">trigger</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="type_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Type</xsl:with-param>
			<xsl:with-param name="sv">Type</xsl:with-param>
			<xsl:with-param name="fr">Type</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="model_text">
		<xsl:call-template name="getText">
			<xsl:with-param name="en">Model</xsl:with-param>
			<xsl:with-param name="sv">Model</xsl:with-param>
			<xsl:with-param name="fr">Model</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<!-- end schedule-->
	
	<xsl:template name="getText">
		<xsl:param name="en"/>
		<xsl:param name="sv"/>
		<xsl:param name="fr"/>
		<xsl:choose>
			<xsl:when test="$language = 'us' or $language = 'ue'"><xsl:value-of select="$en"/></xsl:when>
			<xsl:when test="$language = 'sv'"><xsl:value-of select="$sv"/></xsl:when>
			<xsl:when test="$language = 'fr'"><xsl:value-of select="$fr"/></xsl:when>
			<!-- default: english -->
			<xsl:otherwise><xsl:value-of select="$en"/></xsl:otherwise>		
		</xsl:choose>
	</xsl:template>
	
	
	
</xsl:stylesheet>

