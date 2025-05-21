@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Order Items View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ITEMS_YS 
  as select from zorder_items
  association to parent ZI_ORDER_YS as _Order on $projection.OrderUUID = _Order.OrderUUID
{
  key item_uuid as ItemUUID,
      order_uuid as OrderUUID,
      name as Name,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price as Price,
      currency_code as CurrencyCode,
      quantity as Quantity,
      
      // Administrative fields
      @Semantics.user.createdBy: true
      created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChanged,
      
      // Association
      _Order
}
