var Chart = require('chart.js');
window.addEventListener('load', () => {
  var ctx = document.getElementById("myChart");
  var myChart = new Chart(ctx, {
    //線グラフ
    type: "line",
    //データ
    data: {
      //各データの時間
      labels: JSON.parse(ctx.dataset.labels),
      //データセット
      datasets: [
        {
          lineTension: 0.1,
          label: "体温",
          data: JSON.parse(ctx.dataset.data),
          fill: false,
        }
      ]
    },
    //グラフ設定
    options: {
      elements: {
        point: {
          radius: 0
        },
      },
      //凡例は非表示
      legend: {
          display: false
        },
        scales: {
          //X軸
          xAxes: [
            {
              //軸ラベル表示
              scaleLabel: {
                display: true,
                labelString: "月日"
              },
              //ここで軸を時間を設定する
              type: "time",
              time: {
                unit: 'day',
                displayFormats: {
                  day: 'MM/DD(ddd)'
                }
              },
              //X軸の範囲を指定
              ticks: {
                source: 'auto',
                min: ctx.dataset.start,
                max: ctx.dataset.end
              }
            }
          ],
          //Y軸
          yAxes: [
            {
              //軸ラベル表示
              scaleLabel: {
                display: true,
                labelString: "体温"
              },
              //Y軸の範囲を指定
              ticks: {
                min: 34.0,
                max: 42.0
              }
            }
          ]
        },
        tooltips: {
          callbacks: {
            title: function (tooltipItem, data) {
              var weekday = ["日", "月", "火", "水", "木", "金", "土"];
              var focusPoint = new Date(tooltipItem[0].label);
              var year = focusPoint.getFullYear();
              var month = focusPoint.getMonth() + 1;
              var day = focusPoint.getDate();
              var hour = ("0" + focusPoint.getHours()).slice(-2);
              var min = ("0" + focusPoint.getMinutes()).slice(-2);

              formatDay = year + '年' + month + '月' + day + '日' + '(' + weekday[focusPoint.getDay()] + ') ' + hour + ":" + min;

              return formatDay;
            },
          }
        },
      },
      plugins: [{
        beforeRender: (x, options) => {
          const c = x.chart;
          const dataset = x.data.datasets[0];
          const yScale = x.scales['y-axis-0'];
          const yPos_danger = yScale.getPixelForValue(38.5);
          const yPos_warning = yScale.getPixelForValue(37.5);
          const gradientFill = c.ctx.createLinearGradient(0, 0, 0, c.height);
          gradientFill.addColorStop(0, '#dc3545');//赤
          gradientFill.addColorStop(yPos_danger / c.height, '#dc3545');//赤
          gradientFill.addColorStop(yPos_danger / c.height, '#ffc107');//黄色
          gradientFill.addColorStop(yPos_warning / c.height, '#ffc107');//黄色
          gradientFill.addColorStop(yPos_warning / c.height, '#007bff');//緑
          gradientFill.addColorStop(1, '#007bff');//緑

          const model = x.data.datasets[0]._meta[Object.keys(dataset._meta)[0]].dataset._model;
          model.borderColor = gradientFill;
        },
      }]
    });
})

document.addEventListener('DOMContentLoaded', function() {
  var toggleButton = document.getElementById('display-ago-toggle');
  toggleButton.addEventListener('click', function() {
    window.location.href = toggleButton.getAttribute('href')
  });
});