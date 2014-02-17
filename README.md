HearthStats
===========

Detailed Hearthstone match statistics and tracking.

Sample API call:
----------------

The HearthStats API

*Response*
```json
	{"status":"success","data":{"complete":false,"created_at":"2014-01-25T19:15:53Z","dust":0,"gold":0,"id":1833,"notes":null,"patch":"current","updated_at":"2014-01-25T19:15:53Z","user_id":1,"userclass":"Rogue"}}
```
### Arena

*Last Arena Run*
<pre>
http://localhost:3000/api/v1/arena_runs/show?userkey=secret
</pre>

*Start Arena Run*
<pre>
curl -X POST -H "Content-Type: application/json" -d '{ "klass_id": 2 }' localhost:3000/api/v1/arena_runs/new?userkey=0e7f8484496dd312c589ef21a507c393
</pre>

*End Arena Run*
<pre>
curl localhost:3000/api/v1/arena_runs/end?userkey=0e7f8484496dd312c589ef21a507c393
</pre>

*Arena Entry*
<pre>
curl -X POST -H "Content-Type: application/json" -d '{"klass_id": 1, "oppclass_id": 3,"result_id": 3 ,"coin":"false", "mode_id":1, "oppname":"MubaMu22ba", "notes":"Schooling"}' localhost:3000/api/v1/matches/new?userkey=7d58fa431951c92ceb9b9cb44d481108
</pre>

### Constructed

*Constructed Entry*
<pre>

curl -X POST -H "Content-Type: application/json" -d '{"slot":1,"klass_id": 5, "oppclass_id": 3,"result_id": 1 ,"coin":"false", "rank_id":1, "mode_id":3, "oppname":"MubaMu22ba"}' localhost:3000/api/v1/matches/new?userkey=7d58fa431951c92ceb9b9cb44d481108

</pre>

Contact
-------

Email: jeff@hearthstats.net
