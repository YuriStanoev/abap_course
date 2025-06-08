@EndUserText.label: 'Order Items Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ORDER_ITEMS
  as projection on ZI_ITEMS_YS
{
  key ItemUUID,
      OrderUUID,
      Name,
      Price,
      @EndUserText.label: 'Currency'
      @Semantics.currencyCode: true
      CurrencyCode,
      Quantity,
      
      // Administrative fields
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChanged,
      
      // Association
      _Order : redirected to parent ZC_ORDER_MASTER
}
