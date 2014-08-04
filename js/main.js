$(function(){

  /* jQuery for Sidebar active list */
  var sPath = window.location.pathname;
  var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
  $('a[href="'+ sPage +'"]').parent().addClass('active');

  /* Click and get dropdown list */
  $('.dropdown-toggle').dropdown()

  $('.dropdown a').click (function(e){
    e.preventDefault();
    var dd = $(this).closest('.dropdown');
    dd.find('button.dropdown-toggle').html($(this).text() + ' <span class="caret"></span>')
  })
  $('.dropdown').each(function(){
    $('button.dropdown-toggle', this).html($('a:first', this).text()+ ' <span class="caret"></span>');
  })

  /* Highchart js */

  $('#container').highcharts({

    xAxis: {
      categories: [ 
      'week 1', 'week 2', 'week 3', 'week 4', 'week 4', 'week 5',
      'week 6', 'week 7', 'week 8', 'week 9'
      ]
    },
    yAxis: {
      title: {
        text: 'Features'
      },
      plotLines: [{
        value: 0,
        width: 1,
        color: '#808080'
      }]
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'middle',
      borderWidth: 0
    },
    series: [{
      name: 'Number of Features',
      data: [
      2, 3, 4, 5, 5, 5, 8, 8, 8, 9
      ]
    }, {
      name: 'Implemented Features',
      data: [
      1, 1, 2, 3, 4, 4, 5, 5, 6, 8
      ]
    }, 
    {
      name: 'Backlog',
      data: [
      1.0, 2, 2, 2, 1, 1, 3, 3, 2, 1
      ]
    },
    {
      name: 'Features Failed',
      data: [
      0, 1, 1, 1, 2, 2, 2.5, 2, 2, 3
      ]
    }, {
      name: 'Bugs',
      data: [
      1, 1, 1, 2, 3, 3, 3, 4, 4, 5
      ]
    }]  
  });

  /* Piechart Graph JS */

  $('#piechart-container').highcharts({
    chart: {
      plotBackgroundColor: null,
plotBorderWidth: 1,//null,
plotShadow: false
},
title: {
  text: 'Browser market shares at a specific website, 2014'
},
tooltip: {
  pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
},
plotOptions: {
  pie: {
    allowPointSelect: true,
    cursor: 'pointer',
    dataLabels: {
      enabled: true,
      format: '<b>{point.name}</b>: {point.percentage:.1f} %',
      style: {
        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
      }
    }
  }
},
series: [{
  type: 'pie',
  name: 'Features',
  data: [
  ['Ready for Dev', 16],
  ['In Progress', 10],
  ['QA',     5],
  ['Done',   15]
  ]
}]
});
  /*changing the heading by default*/
  var value = $("#first-project").next().text();
  $("#burndown-charts").text(value);

  /*changing heading on radio button change*/
  changeHeading = function(elem){
    $(elem).change(function(){
      var text = $(elem).next().text()
      $("#burndown-charts").text(text)
      $("#sh").text(text)
    })
  }
  changeHeading("#first-project")
  changeHeading("#second-project")
  changeHeading("#third-project")
});


