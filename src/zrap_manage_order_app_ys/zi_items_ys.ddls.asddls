@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Items Interface View'
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
      created_by as CreatedBy,
      created_at as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
            /* Associations */
      _Order
}
