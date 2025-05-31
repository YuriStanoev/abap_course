@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders Master View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ORDER_YS
  as select from zorder_master
  composition [0..*] of ZI_ITEMS_YS     as _Items
  association [0..1] to /DMO/I_Customer as _Customer on $projection.Customer = _Customer.CustomerID
  association [0..1] to I_Country       as _Country  on $projection.DeliveryCountry = _Country.Country
{
  key order_uuid                as OrderUUID,
      order_id                  as OrderID,
      name                      as Name,
      status                    as Status,
      customer_id               as Customer,
      creation_date             as CreationDate,
      cancellation_date         as CancellationDate,
      completion_date           as CompletionDate,
      delivery_country          as DeliveryCountry,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price               as TotalPrice,
      currency_code             as CurrencyCode,

      cast('' as abap.char(10)) as Complexity,

      // Administrative fields
      @Semantics.user.createdBy: true
      created_by                as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by           as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at           as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at     as LocalLastChanged,

      // Associations
      _Items,
      _Customer,
      _Country
}
