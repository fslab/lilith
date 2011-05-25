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


lecture = Category.find_or_create_by_eva_id('V')
lecture.update_attributes(:name => 'Vorlesung')

exercise = Category.find_or_create_by_eva_id('Ü')
exercise.update_attributes(:name => 'Übung')

practical_training = Category.find_or_create_by_eva_id('P')
practical_training.update_attributes(:name => 'Praktikum')

seminar = Category.find_or_create_by_eva_id('S')
seminar.update_attributes(:name => 'Seminar')
