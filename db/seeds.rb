# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

welcome_article = Article.find_or_create_by_id('7c8bd45e-727a-11e0-8f64-002186a0cd2f')

welcome_article.attributes = {
  :name_de => 'Willkommen zu Lilith',
  :name_en => 'Welcome to Lilith',
  :sticky => true,
  :published => true
}

welcome_article.body_de = <<-TEXT
*Lilith* trägt stündlich, automatisiert Studieninformationen aus verschiedenen öffentlichen Quellen zusammen und ermöglicht dir deinen persönlichen Stundenplan zusammenzustellen.

Anschließend kann dieser mittels des iCalendar-Dateiformats in deine präferierte Kalender-Anwendung exportiert werden.

p=. !/images/start_de.png(Zum starten hier klicken!)!:/de/schedules
TEXT

welcome_article.body_en = <<-TEXT
*Lilith* automatically collects study information from different sources hourly and allows you to create a personal schedule.

Afterwards this schedule can be exported to your favorite calendar application through the iCalendar file format.

p=. !/images/start_en.png(Click to start!)!:/en/schedules
TEXT

welcome_article.save!


beta_article = Article.find_or_create_by_id('2b2d137a-727f-11e0-b04f-002186a0cd2f')

beta_article.attributes = {
  :name_de => 'Warnung: βeta-Test-Version',
  :name_en => 'Warning: βeta-test version',
  :sticky => true,
  :published => true
}

beta_article.body_de = <<-TEXT
Dies ist eine βeta-Version und es ist anzunehmen, dass sie noch größere Fehler enthält.

*Lilith* wird als Open-Source-Projekt von einem kleinen Studenten-Team im *Free Software Lab* entwickelt. Wir sind stets auf der Suche nach weiteren Mitstreitern.

Solltest du Interesse haben dich unserem Entwicklerteam anzuschließen, melde dich einfach! Unsere weitreichenden Vorhaben umfassen Aufgaben in einem großen Spektrum von Schwierigkeitsgraden.

Kontaktdaten und mehr Informationen über das *Lilith*-Projekt findet ihr "hier":/de/imprint .
TEXT

beta_article.body_en = <<-TEXT
This is a βeta version, it is expected to still contain some bigger errors.

*Lilith* is developed as an open-source project by a small team of stundents in the *Free Software Lab*. We are constantly looking for more team members.

Should you be interested to join our development team, just contact us! Our many ideas for the future include tasks in a variety of difficulties.

Contact data and more information about the *Lilith* project can be found "here":/en/imprint .
TEXT

beta_article.save!


ws11_compatibility = Article.find_or_create_by_id('94da3bb2-d419-11e0-b18b-001f160e032b')

ws11_compatibility.attributes = {
  :name_de => 'WS11 Kompatibilität ist in Arbeit',
  :name_en => 'WS11 compatibility in process',
  :sticky => false,
  :published => true
}

ws11_compatibility.body_de = <<-TEXT
Lilith funktioniert aktuell *noch* nicht mit dem WS11 "Stundenplan":https://eva2.inf.h-brs.de/stundenplan/.

Wir arbeiten an einer Lösung. Wenn du die Problembeseitigung beschleunigen möchtest, nimm mit uns "Kontakt":https://lilith.fslab.de/de/imprint auf.
TEXT


ws11_compatibility.body_en = <<-TEXT
Lilith is *currently* not working with the WS11 "timetable":https://eva2.inf.h-brs.de/stundenplan/.

Stay tuned. We are working on a solution. If you want to accelerate the debugging process, just "contact":https://lilith.fslab.de/en/imprint us.
TEXT

ws11_compatibility.save!


ws11_compatibility_ready = Article.find_or_create_by_id('70ba0c28-d804-11e0-9ea8-001f160e032b')

ws11_compatibility_ready.attributes = {
  :name_de => 'WS11/12 Semester Stundenpläne',
  :name_en => 'WS11/12 schedule creation',
  :sticky => true,
  :published => true
}

ws11_compatibility_ready.body_de = <<-TEXT
Einige Änderungen waren notwendig, damit *Lilith* mit dem Stundenplan für das Winter Semester 2011/2012 der Hochschule Bonn-Rhein-Sieg funktioniert.

Darüber hinaus wurde *Lilith* natürlich auch in anderen Richtungen weiterentwickelt. So haben wir weitere Funktionalitäten hinzugefügt, die Bedienung verbessert und die Unterstützung von weiteren offenen Standards voran getrieben.
Sämtliche Neuerungen könnt ihr dem Changelog entnehmen.

Sollten dir Fehler auffallen, "teile":https://lilith.fslab.de/de/imprint sie uns doch bitte mit oder "behebe":https://projects.fslab.de/redmine/projects/lilith sie direkt selbst.
TEXT


ws11_compatibility_ready.body_en = <<-TEXT
A lot of changes were necessary that *Lilith* works with winter semester 2011/2012 Bonn-Rhine-Sieg University of Applied Sciences.

Some additional changes were made, so that *Lilith* has a greater functionality, is easier to use and supports more open standards than the older versions.
All changes are documented in the change log.

If you have any problems, please "report":https://lilith.fslab.de/en/imprint or "fix":https://projects.fslab.de/redmine/projects/lilith it.
TEXT

ws11_compatibility_ready.save!



lecture = Category.find_or_create_by_eva_id('V')
lecture.update_attributes(:name => 'Vorlesung')

exercise = Category.find_or_create_by_eva_id('Ü')
exercise.update_attributes(:name => 'Übung')

practical_training = Category.find_or_create_by_eva_id('P')
practical_training.update_attributes(:name => 'Praktikum')

seminar = Category.find_or_create_by_eva_id('S')
seminar.update_attributes(:name => 'Seminar')

dmeiss2s = User.create(
  :login => 'dmeiss2s',
  :name  => 'Daniel Meißner'
)

afisc12s = User.create(
  :login => 'afisc12s',
  :name  => 'Alexander Emmerich Fischer'
)

[dmeiss2s, afisc12s].each do |user|
  user.roles << User::Role::ADMIN unless user.roles.include?(User::Role::ADMIN)
end