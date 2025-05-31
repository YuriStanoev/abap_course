@EndUserText.label: 'Domain Status Text'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_DOMAIN_STATUS_TEXT
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZORDER_STATUS_YS' ) as DomainText
{
  key DomainText.domain_name as DomainName,
  key DomainText.value_position as ValuePosition,
  key DomainText.language    as Language,
      DomainText.value_low   as DomainValue,
      DomainText.text        as Description
}
where
  DomainText.language = 'E'
