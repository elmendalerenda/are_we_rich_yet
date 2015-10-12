function submitForm() {
  $.post(
      '/spread',
      {
        "stocks": $('#stocks').val(),
        "grantdate": $('#grantdate').val(),
        "strikeprice": $('#strikeprice').val(),
        "cliff_pct": $('#cliff_pct').val(),
        "cliff_n_months": $('#cliff_n_months').val(),
        "vesting_period": $('#vesting_period').val(),
        "market_price": $('#market_price').val()
      },
      function (result){
        $('#spread').text('$ ' + Number(JSON.parse(result)['spread']).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
        $('#spread').show();
      }
  );
}

$(document).ready(function() {
  $("#form").submit(function(e){
    e.preventDefault();
    submitForm();
  });
});

$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})
