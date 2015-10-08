function submitForm() {
  $.post(
      '/spread',
      {
        "stocks": $('#stocks').val(),
        "grantdate": $('#grantdate').val(),
        "strikeprice": $('#strikeprice').val()
      },
      function (result){
        $('#spread').text('$ ' + Number(JSON.parse(result)['spread']).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'))
      }
  );
}

$(document).ready(function() {
  $("#form").submit(function(e){
    e.preventDefault();
    submitForm();
  });
});
