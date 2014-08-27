# whitewall

The whitewall plugin gives you a better overview of your work mates activities displayed in a table matrix per week.
In addition there is Whitewall Graph page which shows the current workload per week.

## Installation

**Clone repository:**

```
git clone https://github.com/ochorocho/whitewall.git
```

**Migrate DB:**

```
rake redmine:plugins:migrate RAILS_ENV=production
```

**Restart Redmine:**

```
cd /your/redmine/root/
touch tmp/restart.txt
```

**User access:**

Go to Administration -> Plugins -> Configure (Whitewall plugin), see "Allowed Groups" and check each group you want to give access to the Whitewall Plugin


**Additional configuration:**

* Tracker colors: Give each Tracker a color to display it on the wall
* Graph: Add a line to the graph to idicate a max. hours limit


**Found a Bug or a way to improve the code?**

Please create a [New Issue](https://github.com/ochorocho/whitewall/issues) in my Github repo: 

