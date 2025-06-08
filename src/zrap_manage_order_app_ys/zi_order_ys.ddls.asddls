@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders Master View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ORDER_YS
  as select from zorder_master
  composition [0..*] of ZI_ITEMS_YS           as _Items
  association [0..1] to /DMO/I_Customer       as _Customer    on  $projection.Customer = _Customer.CustomerID
  association [0..1] to I_Country             as _Country     on  $projection.DeliveryCountry = _Country.Country
  association [0..1] to I_CountryText         as _CountryText on  $projection.DeliveryCountry = _CountryText.Country
                                                              and _CountryText.Language       = $session.system_language
  association [0..1] to ZI_DOMAIN_STATUS_TEXT as _StatusText  on  $projection.Status = _StatusText.DomainValue
{
  key order_uuid                                                    as OrderUUID,
      order_id                                                      as OrderID,
      name                                                          as Name,
      status                                                        as Status,
      case status
      when 'P' then 2
      when 'C'then 3
      when 'X' then 1
      else 0
      end                                                           as StatusCriticality,
      _StatusText.Description                                       as StatusText,
      customer_id                                                   as Customer,
      @EndUserText.label: 'Customer Name'     /////
      concat_with_space(_Customer.FirstName, _Customer.LastName, 1) as CustomerName,
  
      creation_date                                                 as CreationDate,
      cancellation_date                                             as CancellationDate,
      completion_date                                               as CompletionDate,
      delivery_country                                              as DeliveryCountry,
      @EndUserText.label: 'Delivery Country Name'
      _CountryText.CountryName                                      as DeliveryCountryName,
      currency_code                                                 as CurrencyCode,

      // Administrative fields
      @Semantics.user.createdBy: true
      created_by                                                    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                                    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                               as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                               as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                         as LocalLastChanged,

      // Associations
      _Items,
      _Customer,
      _Country,
      _CountryText,
      _StatusText

}
