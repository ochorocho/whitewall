# whitewall

The whitewall plugin gives you a better overview of your work mates activities displayed in a table matrix per week.
In addition there is Whitewall Graph page which shows the current workload per week.

## Installation

_Clone repository:_

```
git clone https://github.com/ochorocho/whitewall.git
```

_Migrate DB:_

```
rake redmine:plugins:migrate RAILS_ENV=production
```

_Restart Redmine:_

```
cd /your/redmine/root/
touch tmp/restart.txt
```

_User access:_

Go to Administration -> Plugins -> Configure (Whitewall plugin), see "Allowed Groups" and check each group you want to give access to the Whitewall Plugin


_Additional configuration:_

* Tracker colors: Give each Tracker a color to display it on the wall
* Graph: Add a line to the graph to idicate a max. hours limit


**Found a Bug or a way to improve the code?**

Please create a [New Issue](https://github.com/ochorocho/whitewall/issues) in my Github repo: 

