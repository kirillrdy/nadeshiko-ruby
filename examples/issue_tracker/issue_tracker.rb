#!/usr/bin/env ruby
require_relative 'boot'

class Nadeshiko::List < Nadeshiko::Element

  attr_accessor :records

  def initialize options={}
    super
    @element_type = :div
    @records = []
  end

  def set_item_renderer &block
    @item_renederer = block
  end


  def load_records records
    #add record
  end

  def append_record record
    @records << record
    @elements_hash ||= {}
    @records_hash ||= {}
    @app.append_to(@id) do
      new_element = @item_renederer.call(record)
      @elements_hash[record.id] = new_element
      @records_hash[new_element.id] = record
    end
  end

#  def sort_by &block
#    
#  end

  def onremove &block
    @onremove = block
  end

  def onsortupdate &block
    
  end

  def remove record
    @onremove.call record if @onremove
    @records.delete record
    @records_hash.delete record
    #elements_hash delete
    @elements_hash[record.id].remove
  end

  def setup

    if @options[:sortable]
      sortable
      sortupdate do |moved_item_id|
        moved_item_id
        get_element moved_item_id
        get_element(moved_item_id).index do |index|
          @records.delete @records_hash[moved_item_id]
          @records.insert(index,@records_hash[moved_item_id])
        end
      end
    end

  end

end

class IssueTracker < Nadeshiko::Application

  include Styling
  include EventHandlers
  include Layout
  include Notifications
  include Methods


  def onstart
    list :id => :list1,:sortable => true

    list = get_element(:list1)

    list.set_item_renderer do |record|
      div  :class => "well" do
        story_description = "#{record.id}: #{record.description}"
        div :text => story_description, :class => 'issue-description left'
        x = div :text => 'Delete', :class => 'btn danger right'
        x.click do
          list.remove record
        end
      end
    end

#    list.onremove do |record|
#      record.destroy
#    end

    Issue.all.each do |issue|
      list.append_record issue
    end

    issues_styling
#    initial_layout
#    setup_notificaitons
#    issue_events

  end

end

Nadeshiko::Server.run IssueTracker
