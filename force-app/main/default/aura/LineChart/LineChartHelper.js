/**
 * Created by naveen on 26/02/19.
 */
({
    createLineGraph : function(component, temp) {
        console.log('createLineGraph');
        var label = [];
        var firstValue = [];
        var option = {
          responsive: false,
          maintainAspectRatio : true,
          legend: {
              display: false
          },
          scales: {
              yAxes: [{
                gridLines: {
                  display: true,
                  color: "rgba(255,99,132,0.2)"
                }
              }],
              xAxes: [{
                gridLines: {
                  display: false
                },
                ticks: {
                    userCallback: function(item, index) {
                        if (!(index % 4)) return item;
                        else return '';
                    },
                    fontSize: 15,
                    maxRotation: 0,
                    minRotation: 0
                }
              }]
            }
        };
        for(var a=0; a< temp.length; a++){
            label.push(temp[a]["label"]);
            firstValue.push(temp[a]["firstValue"]);
        }
        console.log('Label: ', label);
        console.log('FirstValue: ', firstValue);
        var el = component.find('lineChart').getElement();
        var ctx = el.getContext('2d');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: label,
                datasets: [{
                    label: component.get('v.tag'),
                    data: firstValue,
                    backgroundColor: component.get('v.lineColor'),
                    borderColor: component.get('v.lineColor'),
                    fill : false,
                    pointRadius : 0,
                    borderWidth : 1
                }]
            },
            options: option
        });
    }
})