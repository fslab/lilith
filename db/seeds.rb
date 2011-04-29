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
*Lilith* trägt Studieninformationen aus verschiedensten öffentlichen Quellen zusammen und ermöglicht dir deinen persönlichen Stundenplan zusammenzustellen.

Anschließend kann dieser mittels des iCalendar-Dateiformats in deine präferierte Kalender-Anwendung exportiert werden.

p=. !images/start_de.png(Zum starten hier klicken!)!:de/schedules
TEXT

welcome_article.body_en = <<-TEXT
*Lilith* collects study information from different sources and allows you to create a personal schedule.

Afterwards this schedule can be exported to your favorite calendar application through the iCalendar file format.

p=. !images/start_en.png(Click to start!)!:en/schedules
TEXT

welcome_article.save!


beta_article = Article.find_or_create_by_id('2b2d137a-727f-11e0-b04f-002186a0cd2f')

beta_article.attributes = {
  :name_de => 'Warnung: Beta-Test-Version',
  :name_en => 'Warning: Beta-test version',
  :sticky => true,
  :published => true
}

beta_article.body_de = <<-TEXT
*Lilith* wird als Open-Source-Projekt von einem kleinen Studenten-Team im *Free Software Lab* entwickelt.

Dies ist eine Test-Version und es ist anzunehmen, dass sie noch Fehler enthält.

Solltest du Interesse haben dich unserem Entwicklerteam anzuschließen melde dich einfach! Wir haben auch Aufgaben für Einsteiger zu vergeben.

Mehr Informationen zum Projekt *Lilith* erhälst du "hier":de/imprint .
TEXT

beta_article.body_en = <<-TEXT
*Lilith* is developed as an Open-source project by a small team of stundents in the *Free Software Lab*.

This is a test version, it is expected to still contain some bigger errors.

Should you be interested to join our development team, just contact us! We have tasks for every grade of experienced developer.

More information about the *Lilith* project can be seen "here":en/imprint .
TEXT

beta_article.save!


Category.create!(:eva_id => 'V', :name => 'Vorlesung')
Category.create!(:eva_id => 'Ü', :name => 'Übung')
Category.create!(:eva_id => 'P', :name => 'Praktikum')
Category.create!(:eva_id => 'S', :name => 'Seminar')
