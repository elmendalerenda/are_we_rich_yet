function submitForm() {
  $.post(
      '/spread',
      {
        "stocks": $('#stocks').val(),
        "grantdate": $('#grantdate').val(),
        "strikeprice": $('#strikeprice').val()
      },
      function (result){
        $('#spread').text(JSON.parse(result)['spread'])
      }
  );
}

$('#get-spread').click(function () {
  submitForm();
})
