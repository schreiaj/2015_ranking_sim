console.log "'Allo from CoffeeScript!"

#+ Jonas Raoni Soares Silva
#@ http://jsfromhell.com/array/shuffle [v1.0]

getQueryVariable = (variable) ->
  query = window.location.search.substring(1)
  vars = query.split("&")
  i = 0

  while i < vars.length
    pair = vars[i].split("=")
    return pair[1]  if pair[0] is variable
    i++
  false

window.executeMatch = executeMatch = (match) ->
  # Simulate a match, alliance score is sum of skills * meanMatchScore
  # Add the match score to each team's record
  teams[findTeam(match.r1.number)].matches.push((match.r1.skill+match.r2.skill+match.r3.skill)*meanMatchScore)
  teams[findTeam(match.r2.number)].matches.push((match.r1.skill+match.r2.skill+match.r3.skill)*meanMatchScore)
  teams[findTeam(match.r3.number)].matches.push((match.r1.skill+match.r2.skill+match.r3.skill)*meanMatchScore)
  teams[findTeam(match.b1.number)].matches.push((match.b1.skill+match.b2.skill+match.b3.skill)*meanMatchScore)
  teams[findTeam(match.b2.number)].matches.push((match.b1.skill+match.b2.skill+match.b3.skill)*meanMatchScore)
  teams[findTeam(match.b3.number)].matches.push((match.b1.skill+match.b2.skill+match.b3.skill)*meanMatchScore)
  # Some record keeping for UI
  match.redScore = (match.r1.skill+match.r2.skill+match.r3.skill)*meanMatchScore
  match.blueScore = (match.b1.skill+match.b2.skill+match.b3.skill)*meanMatchScore
  # sort the teams and push a copy into the rankings
  rankings.push(teams.sort((a,b) -> d3.mean(b.matches) - d3.mean(a.matches)))
  for team, rank in teams
    team.ranks.push(rank+1)

window.findTeam = findTeamIndex = (teamNo) ->
  for team, index in teams
    if team.number == teamNo
      return index
  return -1

window.teams = teams = []

numTeams = parseInt(getQueryVariable("teams"))||40
matches = parseInt(getQueryVariable("matches"))||12
maxTeamNo = 1000
lamda = 1.5
meanMatchScore = 80
console.log numTeams,matches

window.rankings = rankings = []

visualHeight = 800
visualWidth = 1000
offset = 40

for team in d3.range(0, numTeams)
  teams.push({number: Math.floor(Math.random() * maxTeamNo)+1, skill: jStat.exponential.sample(lamda), matches: [], ranks:[]})

teams.sort((a,b) -> a.skill-b.skill)

# d3.select(".container").append("ul").selectAll("li").data(teams).enter().append("li").text((d) ->d.number + "-" + numeral(d.skill).format('0.0'))


d3.text("/scripts/schedules/#{numTeams}_#{matches}.csv", (data)->
    scheduleTemplate = d3.csv.parseRows(data)
    window.schedule = []
    # initial ranking is optimal
    rankings.push(teams.sort((a,b) -> b.skill - a.skill))
    for team, rank in teams
      team.ranks.push(rank+1)
    # for team in teams
    #   console.log team.skill
    # # Shuffle Teams
    d3.shuffle(teams)
    for match in scheduleTemplate
      window.schedule.push({r1: teams[parseInt(match[0]-1)], r2: teams[parseInt(match[2]-1)], r3: teams[parseInt(match[4]-1)], b1: teams[parseInt(match[6]-1)], b2: teams[parseInt(match[8]-1)], b3: teams[parseInt(match[10]-1)]})
    for match in window.schedule
      executeMatch(match)
    row = d3.select("#schedule > tbody").selectAll("tr").data(window.schedule).enter().append("tr")
    row.append("td").text((d, i) -> i+1)
    row.append("td").text((d, i) -> d.r1.number)
    row.append("td").text((d, i) -> d.r2.number)
    row.append("td").text((d, i) -> d.r3.number)
    row.append("td").text((d, i) -> d.b1.number)
    row.append("td").text((d, i) -> d.b2.number)
    row.append("td").text((d, i) -> d.b3.number)
    row.append("td").text((d, i) -> numeral(d.redScore).format('0'))
    row.append("td").text((d, i) -> numeral(d.blueScore).format('0'))


    window.rankScale = rankScale = d3.scale.ordinal().domain(d3.range(1,numTeams+1)).rangePoints([offset, visualHeight])
    window.matchScale = matchScale = d3.scale.ordinal().domain(d3.range(0, window.schedule.length+1)).rangePoints([offset, visualWidth])
    colorScale = d3.scale.category20()
    teams.sort((a,b) -> b.skill - a.skill)
    row = d3.select("#analysis > tbody").selectAll("tr").data(teams).enter().append("tr")
    row.append("td").text((d, i) -> d.number)
    row.append("td").text((d, i) -> d.ranks[0])
    row.append("td").text((d, i) -> d.ranks[d.ranks.length-1])
    row.append("td").text((d, i) -> d3.min(d.ranks))
    row.append("td").text((d, i) -> d3.max(d.ranks))
    row.append("td").text((d, i) -> numeral(d3.mean(d.ranks)).format("0"))
    pathGenerator = d3.svg.line().x((d,i) -> matchScale(i)).y((d,i) -> rankScale(d)).interpolate("monotone")
    for team, index in teams
      # console.log team.number + ":" + team.skill + team.ranks
      d3.select("#rankVisual").append("path").classed('team', true).classed("frc#{team.number}", true).datum(team.ranks).attr("d", pathGenerator).attr("stroke", colorScale(index))

      d3.select("#rankVisual").append("text").datum(team).text(team.number).attr("transform", "translate(0,#{rankScale(team.ranks[0])})")
      .on("mouseover", (d) ->
        d3.selectAll(".team").attr("opacity",".1")
        d3.select(".frc#{d.number}").attr("opacity","1").classed('highlight', true)
      )
      .on("mouseout", () ->
        d3.selectAll(".team").attr("opacity","1").classed("highlight", false)

      )
)
