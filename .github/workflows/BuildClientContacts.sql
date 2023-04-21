USE vista;

/****** Script for Building ClientContacts Table in BullHorn  ******/
SELECT 
j.billing_contact_id AS LegacyID,
/**'' AS LegacySystem,
**/
clt.entity_id_number AS ClientCorporationID,
/**'' AS LinkedCandidateID,
'' AS namePrefix,
**/
[dbo].FormatWord(nl.[entity_first_name]) AS 'firstName',
[dbo].FormatWord(nl.[entity_middle_name]) AS middleName,
[dbo].FormatWord(nl.[entity_name]) AS lastName,
[dbo].FormatWord(nl.[title]) AS nameSuffix,
/**'' AS nickName,
**/
ed.activation_date AS dateAdded,
/**'' AS status,
'' AS occupation,
**/
COALESCE(em.email_address,'') AS 'email',
/**'' AS email2,
'' AS email3,
**/
[dbo].FormatPhoneNumber(adr.country_code, ph.phone_number) AS phone,
ph.phone AS phone2,
/**'' AS phone3,
'' AS mobile,
**/
[dbo].[FormatPhoneNumber](adr.country_code, fx.phone_number) AS fax,
fx.phone AS fax2,
/**'' AS fax3,
**/
COALESCE(adr.address_1,'') AS address1,
COALESCE(adr.address_2,'') AS address2,
COALESCE([dbo].FormatWord(adr.city),'') AS city,
COALESCE(adr.state,'') AS state,
COALESCE(adr.zip_code,'') AS zip,
COALESCE(adr.country_code,'') AS countryID,
/**'' AS secondaryAddress1,
'' AS secondaryAddress2,
'' AS secondaryCity,
'' AS secondaryState,
'' AS secondaryZip,
'' AS secondaryCountryID,
**/
nl.note AS comments,
/**'' AS dateLastVisit,
'' AS description,
'' AS desiredCategories,
'' AS desiredLocations,
'' AS desiredSkills,
'' AS desiredSpecialties,
'' AS division,
**/
clt.entity_name AS office

FROM jobs as j
LEFT JOIN entity_details as ed  on	j.billing_contact_id = ed.entity_id_number
LEFT JOIN name_list		 as nl  on	ed.entity_id_number = nl.entity_id_number
LEFT JOIN name_list		 as clt on	j.nam_link_id = nl.entity_id_number
LEFT JOIN address		 as adr on	j.billing_address_key_id = adr.key_id
LEFT JOIN phone			 as ph  on	j.billing_contact_id = ph.entity_id_number AND (ph.is_fax = 'N' or ph.is_fax is null)
LEFT JOIN email_address	 as em  on	j.billing_contact_id = em.entity_id_number
LEFT JOIN phone			 as fx  on	j.billing_contact_id = fx.entity_id_number AND fx.is_fax = 'Y'

WHERE 
ed.activation_date is not null and
em.email_address is not null and
j.billing_contact_id = '236876'

ORDER BY ClientCorporationID