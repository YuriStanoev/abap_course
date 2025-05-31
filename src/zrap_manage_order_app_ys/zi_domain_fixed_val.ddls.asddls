@EndUserText.label: 'Get domain fix values'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.query.implementedBy: 'ABAP:ZCL_GET_DOMAIN_FIX_VALUES'
@Search.searchable: true
define custom entity ZI_DOMAIN_FIXED_VAL
{
      @UI.hidden  : true
  key domain_name : sxco_ad_object_name;
      @UI.hidden  : true
  key pos         : abap.numc( 4 );

      @EndUserText.label : 'Value'
      @ObjectModel.text.element: ['description'] //  Link technical value to description
      low         : abap.char( 20 );

      @EndUserText.label : 'upper_limit'
      @UI.hidden  : true
      high        : abap.char(20);

      @EndUserText.label : 'Description'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Semantics.text: true
      description : abap.char(60);
}
