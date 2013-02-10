$(document).ready(function() {

// Remove the previous handler:
  $('#promotion_event_name').unbind('change');
// toggle fields for specific events
  $('#promotion_event_name').change(function() {
    $('#promotion_code_field').toggle($('#promotion_event_name').val() == 'spree.checkout.coupon_code_added');
    $('#promotion_path_field').toggle($('#promotion_event_name').val() == 'spree.content.visited');
    $('#promotion_groupon_campaign_field').toggle($('#promotion_event_name').val() == 'spree.checkout.groupon_code_added');
    $('#promotion_groupon_codes_file_field').toggle($('#promotion_event_name').val() == 'spree.checkout.groupon_code_added');

  });
  $('#promotion_event_name').change();

});

