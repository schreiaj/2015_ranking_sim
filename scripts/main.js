(function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q;for(console.log("'Allo from CoffeeScript!"),c=function(a){var b,c,d,e;for(d=window.location.search.substring(1),e=d.split("&"),b=0;b<e.length;){if(c=e[b].split("="),c[0]===a)return c[1];b++}return!1},window.executeMatch=a=function(a){var b,c,d,e,f;for(l[findTeam(a.r1.number)].matches.push((a.r1.skill+a.r2.skill+a.r3.skill)*g),l[findTeam(a.r2.number)].matches.push((a.r1.skill+a.r2.skill+a.r3.skill)*g),l[findTeam(a.r3.number)].matches.push((a.r1.skill+a.r2.skill+a.r3.skill)*g),l[findTeam(a.b1.number)].matches.push((a.b1.skill+a.b2.skill+a.b3.skill)*g),l[findTeam(a.b2.number)].matches.push((a.b1.skill+a.b2.skill+a.b3.skill)*g),l[findTeam(a.b3.number)].matches.push((a.b1.skill+a.b2.skill+a.b3.skill)*g),a.redScore=(a.r1.skill+a.r2.skill+a.r3.skill)*g,a.blueScore=(a.b1.skill+a.b2.skill+a.b3.skill)*g,j.push(l.sort(function(a,b){return d3.mean(b.matches)-d3.mean(a.matches)})),f=[],b=d=0,e=l.length;e>d;b=++d)c=l[b],f.push(c.ranks.push(b+1));return f},window.findTeam=b=function(a){var b,c,d,e;for(b=d=0,e=l.length;e>d;b=++d)if(c=l[b],c.number===a)return b;return-1},window.teams=l=[],h=parseInt(c("teams"))||40,e=parseInt(c("matches"))||12,f=1e3,d=1.5,g=80,console.log(h,e),window.rankings=j=[],m=800,n=1e3,i=40,q=d3.range(0,h),o=0,p=q.length;p>o;o++)k=q[o],l.push({number:Math.floor(Math.random()*f)+1,skill:jStat.exponential.sample(d),matches:[],ranks:[]});l.sort(function(a,b){return a.skill-b.skill}),d3.text("schedules/"+h+"_"+e+".csv",function(b){var c,d,e,f,g,o,p,q,r,s,t,u,v,w,x,y,z,A,B;for(r=d3.csv.parseRows(b),window.schedule=[],j.push(l.sort(function(a,b){return b.skill-a.skill})),o=s=0,v=l.length;v>s;o=++s)k=l[o],k.ranks.push(o+1);for(d3.shuffle(l),t=0,w=r.length;w>t;t++)e=r[t],window.schedule.push({r1:l[parseInt(e[0]-1)],r2:l[parseInt(e[2]-1)],r3:l[parseInt(e[4]-1)],b1:l[parseInt(e[6]-1)],b2:l[parseInt(e[8]-1)],b3:l[parseInt(e[10]-1)]});for(A=window.schedule,u=0,x=A.length;x>u;u++)e=A[u],a(e);for(q=d3.select("#schedule > tbody").selectAll("tr").data(window.schedule).enter().append("tr"),q.append("td").text(function(a,b){return b+1}),q.append("td").text(function(a){return a.r1.number}),q.append("td").text(function(a){return a.r2.number}),q.append("td").text(function(a){return a.r3.number}),q.append("td").text(function(a){return a.b1.number}),q.append("td").text(function(a){return a.b2.number}),q.append("td").text(function(a){return a.b3.number}),q.append("td").text(function(a){return numeral(a.redScore).format("0")}),q.append("td").text(function(a){return numeral(a.blueScore).format("0")}),window.rankScale=p=d3.scale.ordinal().domain(d3.range(1,h+1)).rangePoints([i,m]),window.matchScale=f=d3.scale.ordinal().domain(d3.range(0,window.schedule.length+1)).rangePoints([i,n]),c=d3.scale.category20(),l.sort(function(a,b){return b.skill-a.skill}),q=d3.select("#analysis > tbody").selectAll("tr").data(l).enter().append("tr"),q.append("td").text(function(a){return a.number}),q.append("td").text(function(a){return a.ranks[0]}),q.append("td").text(function(a){return a.ranks[a.ranks.length-1]}),q.append("td").text(function(a){return d3.min(a.ranks)}),q.append("td").text(function(a){return d3.max(a.ranks)}),q.append("td").text(function(a){return numeral(d3.mean(a.ranks)).format("0")}),g=d3.svg.line().x(function(a,b){return f(b)}).y(function(a){return p(a)}).interpolate("monotone"),B=[],d=z=0,y=l.length;y>z;d=++z)k=l[d],d3.select("#rankVisual").append("path").classed("team",!0).classed("frc"+k.number,!0).datum(k.ranks).attr("d",g).attr("stroke",c(d)),B.push(d3.select("#rankVisual").append("text").datum(k).text(k.number).attr("transform","translate(0,"+p(k.ranks[0])+")").on("mouseover",function(a){return d3.selectAll(".team").attr("opacity",".1"),d3.select(".frc"+a.number).attr("opacity","1").classed("highlight",!0)}).on("mouseout",function(){return d3.selectAll(".team").attr("opacity","1").classed("highlight",!1)}));return B})}).call(this);