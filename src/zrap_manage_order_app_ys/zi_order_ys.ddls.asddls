@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders Interface View'
define root view entity ZI_ORDER_YS
  as select from zorder_master
  composition [0..*] of ZI_ITEMS_YS as _Items
  association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
  association [0..1] to I_Country       as _Country  on $projection.DeliveryCountry = _Country.Country
{
  key order_uuid as OrderUUID,
      order_id as OrderID,
      name as Name,
      status as Status,
      case status
        when 'P' then 'In Process'
        when 'C' then 'Completed'
        when 'X' then 'Cancelled'
        else 'Unknown Status'
      end as StatusText,
      customer_id as CustomerID,
      _Customer.LastName as CustomerName,
      creation_date as CreationDate,
      cancellation_date as CancellationDate,
      completion_date as CompletionDate,
      delivery_country as DeliveryCountry,
      total_price as TotalPrice,
      currency_code as CurrencyCode,
      created_by as CreatedBy,
      created_at as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      /* Associations */
      _Items,
      _Customer,
      _Country
}
