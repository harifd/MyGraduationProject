
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>统计分析</title>
<link href="JavaScript/MyCSS/warning.css" rel="stylesheet">
<link href="JavaScript/bootstrap-3.3.5-dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="JavaScript/MyCSS/sb-admin.css" rel="stylesheet">
<link href="JavaScript/MyCSS/style.default.css" rel="stylesheet">
<link href="JavaScript/MyCSS/data.css" rel="stylesheet">
<link
	href="JavaScript/bootstrap-datetimepicker/css/bootstrap-datetimepicker.css"
	rel="stylesheet">
<script src="JavaScript/jquery-2.2.1.min.js"></script>
<script type="text/javascript"
	src="JavaScript/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
<script src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
<script type="text/javascript"
	src="JavaScript/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript"
	src="JavaScript/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="JavaScript/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="JavaScript/responsive-tables.js"></script>
<script type="text/javascript" src="JavaScript/myJS.js"></script>
</head>
<body>
	<ul class="breadcrumbs">
		<li><a href="Welcome.html"><i
				class="glyphicon glyphicon-home"></i></a> <span
			class="glyphicon glyphicon-menu-right"></span></li>
		<li>统计分析</li>
	</ul>
	<div id="page-wrapper">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-12">
					<h1 class="page-header" style="margin: 20px 0 20px;">统计分析</h1>

				</div>
			</div>
		</div>
	</div>

	<div style="width: 565px; margin: 0px auto;">
		<div style="float: left; width: 100%;">
			<div style="float: left; margin-right: 15px;">
				<label class="searchLabel">选择月份：</label>
				<div class="input-group date form_datetime col-md-1.5"
					data-link-field="dtp_input1">
					<input id="datetimepicker" class="form-control" size="16"
						type="text" style="border-radius: 0px;" value="" readonly>
				</div>
				<input type="hidden" id="dtp_input1" value="" /><br />
			</div>
			<label class="searchLabel">站点：</label>
			<div class="searchDiv">
				<div class="input-group">
					<input type="text" id="o" onkeyup="autoComplete.start(event)"
						class="form-control" style="border-radius: 0px;"
						placeholder="搜索站点...">
					<div class="auto_hidden" id="auto">
						<!--自动完成 DIV-->
					</div>
					<span class="input-group-btn">
						<button class="btn btn-default" id="searchBtn"
							style="padding-bottom: 7px; padding-top: 7px; border-radius: 0px;"
							type="button">搜索</button>
					</span>
				</div>
			</div>
		</div>
	</div>

	<div class="mydiv" style="display:none;">
	<div id="loding_img"
						style="margin-top: 200px; float: left; text-align: center; width: 100%; display: none;">
						<img src="../MyGraduationProject/Images/loader5.gif" />
					</div>
		<div id="container"
			style="margin: 20px; width: 100%; height: 400px; margin: 0 auto"></div>
	</div>
	<script type="text/javascript">
		var title;
		var yText;
		$.ajax({
			type : "POST",
			dataType : "json",
			url : "getStation.action",
			async : false,
			success : function(data) {
				datalist = data['stationNameList'];
			}
		});
		var autoComplete = new AutoComplete('o', 'auto', datalist);
		$('#datetimepicker').datetimepicker({
			format : 'yyyy-mm',
			weekStart : 1,
			autoclose : true,
			startView : 3,
			minView : 3,
			forceParse : false,
			language : 'zh-CN'
		});

		$('#searchBtn').click(function() {
			time1 = $('#datetimepicker').val()+"-1";
			time2 = $('#datetimepicker').val();
			var year = parseInt(time2.substr(0,4));
			var month = parseInt(time2.substr(5,2));
			if(month+1>12){
				year++;
				month=1;
			}
			else{
				month++;
			}
			time2=year+"-"+month+"-1";
			var station = $('#o').val();
			var params = {
					endTime : time2,
					startTime : time1,
					station : station,
			};
			if (time1 == '') {
				alert("请选择一个月份");
			} else if (station == '') {
				alert("请选择站点");
			} else {
				$('.mydiv').show();
				$('#loding_img').show();
				 $.ajax({
					type : "POST",
					dataType : "json",
					url : "getData.action",
					data : params,
					success : function(data) {
						$('#loding_img').hide();
						if (data['flag'] == '1') {
							title=station+time1+"到"+time2+"河流水位统计数据";
							yText="水位（m）";
						} else if (data['flag'] == '0') {
							title=station+time1+"到"+time2+"水库水位统计数据";
							yText="水位（m）";
						} else if (data['flag'] == '2') {
							title=station+time1+"到"+time2+"降水量统计数据";
							yText="降水量";
						}
						if(data['flag']!='3'){
							result = data['list'];
							var datalist = new Array();
							for(var i=0;i<result.length;i++){
								datalist.push(result[i][1]);
							}
							console.log(datalist);
							$(function() {
								$('#container').highcharts({
									chart: {
										zoomType: 'x',
										spacingRight: 20
									},
									credits: {
							            enabled: false
							        },
									title: {
										text: '水位'
									},
									subtitle: {
										text: null/* document.ontouchstart === undefined ?
										'Click and drag in the plot area to zoom in' :
										'Pinch the chart to zoom in' */
									},
									xAxis: {
										type: title,
						            title: {
						            	text: null
						            }
						        },
						        yAxis: {
						        	title: {
						        		text: yText,
						        	},
						        	plotLines: [{   //一条延伸到整个绘图区的线，标志着轴中一个特定值。
						                color: '#FB3D01',
						                dashStyle: 'Dash', //Dash,Dot,Solid,默认Solid
						                width: 1.5,
						                value: 5,  //y轴显示位置
						                zIndex: 5
						            }]
						        },
						        tooltip: {
						        	shared: true
						        },
						        legend: {
						        	enabled: false
						        },
						        plotOptions: {
						            area: {
						                fillColor: {
						                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
						                    stops: [
						                        [0, Highcharts.getOptions().colors[0]],
						                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
						                    ]
						                },
						                lineWidth: 1,
						                marker: {
						                    enabled: false
						                },
						                shadow: false,
						                states: {
						                    hover: {
						                        lineWidth: 1
						                    }
						                },
						                threshold: null
						            }
						        },

						        series: [{
						        	type: 'area',
						        	name: '水位',
						        	data: datalist
						        }/* ,
						        {	
						        	type:'line',
						            name:'基准线',
						            color:'#FB3D01',
						            data:line,
						        	pointInterval: 24 * 3600 * 1000,
						    		pointStart: Date.UTC(1994, 0, 01),
						       } */
						        ]
						    });
						});
						}
					}
				}); 
			}
		});

		Highcharts.createElement('link', {
			href : 'http://fonts.googleapis.com/css?family=Dosis:400,600',
			rel : 'stylesheet',
			type : 'text/css'
		}, null, document.getElementsByTagName('head')[0]);

		Highcharts.theme = {
			colors : [ "#7cb5ec", "#f7a35c", "#90ee7e", "#7798BF", "#aaeeee",
					"#ff0066", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF",
					"#aaeeee" ],
			chart : {
				backgroundColor : null,
				style : {
					fontFamily : "Dosis, sans-serif"
				}
			},
			title : {
				style : {
					fontSize : '16px',
					fontWeight : 'bold',
					textTransform : 'uppercase'
				}
			},
			tooltip : {
				borderWidth : 0,
				backgroundColor : 'rgba(219,219,216,0.8)',
				shadow : false
			},
			legend : {
				itemStyle : {
					fontWeight : 'bold',
					fontSize : '13px'
				}
			},
			xAxis : {
				gridLineWidth : 1,
				labels : {
					style : {
						fontSize : '12px'
					}
				}
			},
			yAxis : {
				minorTickInterval : 'auto',
				title : {
					style : {
						textTransform : 'uppercase'
					}
				},
				labels : {
					style : {
						fontSize : '12px'
					}
				}
			},
			plotOptions : {
				candlestick : {
					lineColor : '#404048'
				}
			},

			// General
			background2 : '#F0F0EA'

		};

		// Apply the theme
		Highcharts.setOptions(Highcharts.theme);
	</script>
</body>
</html>
