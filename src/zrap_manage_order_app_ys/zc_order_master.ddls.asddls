@EndUserText.label: 'Orders Master Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_ORDER_MASTER
  provider contract transactional_query
  as projection on ZI_ORDER_YS
{
  key OrderUUID,
      @Search.defaultSearchElement: true
      OrderID,
      @Search.defaultSearchElement: true
      Name,
      Status,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID' } }]
      Customer,
      _Customer.LastName as CustomerName,
      CreationDate,
      CancellationDate,
      CompletionDate,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
      DeliveryCountry,

      Complexity,
      TotalPrice,
      CurrencyCode,
      
      
      // Administrative fields
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChanged,
      
      // Associations
      _Items : redirected to composition child ZC_ORDER_ITEMS,
      _Customer,
      _Country
}
