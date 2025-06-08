@EndUserText.label: 'Orders Master Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_ORDER_MASTER
  provider contract transactional_query
  as projection on ZI_ORDER_YS
{
  key        OrderUUID,
             @Search.defaultSearchElement: true
             OrderID,
             @Search.defaultSearchElement: true
             Name,
             @ObjectModel.text.element: [ 'StatusText' ]
             @EndUserText.label: 'Status'
             @Consumption.valueHelpDefinition:
             [{ entity: { name : 'ZI_DOMAIN_FIXED_VAL' , element: 'low' } ,
                          additionalBinding: [{ element: 'domain_name',
                          localConstant: 'ZORDER_STATUS_YS', usage: #FILTER }]
                          , distinctValues: true
             }]
             Status,
             @EndUserText.label: 'Status Description'
             @UI.hidden: true
             StatusText,
             StatusCriticality,

             @ObjectModel.text.element: ['CustomerName']
             @Search.defaultSearchElement: true
             @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID' } }]
             Customer,
             @EndUserText.label: 'Customer Name'
             @UI.hidden: true
             CustomerName,

             CreationDate,
             CancellationDate,
             CompletionDate,
             @ObjectModel.text.element: ['DeliveryCountryName']
             @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
             DeliveryCountry,
             @EndUserText.label: 'Delivery Country Name'
             @UI.hidden: true
             DeliveryCountryName,

             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_COMPLEXITY_CALC'
             @EndUserText.label: 'Order Complexity'
  virtual    Complexity   : abap.char(10),

             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_TOTAL_CALC'
             @EndUserText.label: 'Total Price'
             @Semantics.amount.currencyCode: 'CurrencyCode'
  virtual    TotalPrice   : abap.curr( 15, 2 ),

             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_TOTAL_CALC'
             @EndUserText.label: 'CurrencyCode'
             @Semantics.currencyCode: true
  virtual    CurrencyCode : abap.cuky,
             //          @EndUserText.label: 'Currency'
             //          @Semantics.currencyCode: true
             //          CurrencyCode,


             // Administrative fields
             CreatedBy,
             CreatedAt,
             LastChangedBy,
             LastChangedAt,
             LocalLastChanged,

             // Associations
             _Items : redirected to composition child ZC_ORDER_ITEMS,

             _Customer,
             _Country,
             _StatusText
}
