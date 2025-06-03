@EndUserText.label: 'Orders Master Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_ORDER_MASTER
  provider contract transactional_query
  as projection on ZI_ORDER_YS
{
  key     OrderUUID,
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
          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID' } }]
          Customer,
          _Customer.LastName as CustomerName,
          CreationDate,
          CancellationDate,
          CompletionDate,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
          DeliveryCountry,
          
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_COMPLEXITY_CALC'
          @EndUserText.label: 'Order Complexity'
  virtual Complexity : abap.char(10),
          
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_TOTAL_CALC'
          @EndUserText.label: 'Total Price'
          @Semantics.amount.currencyCode: 'TotalCurrencyCode'
  virtual TotalPrice : abap.curr( 15, 2 ),
          
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_TOTAL_CALC'
          @EndUserText.label: 'TotalCurrencyCode'
          @Semantics.currencyCode: true
 virtual  TotalCurrencyCode:abap.cuky,
          
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
          _Country,
          _StatusText
}
