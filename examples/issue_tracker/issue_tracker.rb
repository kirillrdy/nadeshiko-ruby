#!/usr/bin/env ruby
require_relative 'boot'

class Nadeshiko::List < Nadeshiko::Element

  attr_accessor :records

  def initialize options={}
    super
    @element_type = :div
    @records = []
    @elements = []
    @elements_hash = {}
    @records_hash = {}
  end

  def item_renderer &block
    @item_renederer = block
  end

  def load_records records
    records.each do |record|
      append_record record, :skip_sort_update => true
    end
  end

  def append_record record, options = {}
    if @options[:notify] && options[:notify]
      Nadeshiko::Notifier.trigger :record_appended, record
    else
      append_record_to_list record
    end

    @onsortupdate.call if @onsortupdate && @options[:skip_sort_update] != true

  end

  def append_record_to_list record
    @records << record

    @app.append_to(@id) do
      new_element = @item_renederer.call(record)
      @elements << new_element
      @elements_hash[record.id] = new_element
      @records_hash[new_element.id] = record
    end

  end

  def records_order
    @records.map &:id
  end

  def onremove &block
    @onremove = block
  end

  def onsortupdate &block
    @onsortupdate = block
  end

  def remove record
    if @options[:notify]
      Nadeshiko::Notifier.trigger :record_removed, record
    else
      remove_from_list record
    end
  end

  def remove_from_list record
    @records.delete record
    @records_hash.delete record
    @elements.delete @elements_hash[record.id]
    @elements_hash[record.id].remove
    @onremove.call record if @onremove
    @onsortupdate.call if @onsortupdate
  end

  def move_record_by_index old_index,new_index
    record = @records[old_index]
    @records.delete record
    @records.insert new_index,record

    element = @elements[old_index]
    @elements.delete element
    @elements.insert new_index,element

    if new_index == 0
      element.insert_before @elements[1]
    else
      element.insert_after @elements[new_index-1]
    end
    
    @onsortupdate.call if @onsortupdate
    
  end

  def setup
    if @options[:sortable]
      sortable
      sortupdate do |moved_item_id|
        moved_item = get_element moved_item_id
        moved_item.index do |index|
          old_index = @elements.index moved_item
          Nadeshiko::Notifier.trigger :record_moved,old_index,index
        end
      end
    end

    if @options[:notify]
      #TODO make work with multiple lists
      Nadeshiko::Notifier.bind :record_appended do |record|
        append_record_to_list record
      end

      Nadeshiko::Notifier.bind :record_removed do |record|
        remove_from_list record
      end

      Nadeshiko::Notifier.bind :record_moved do |old_index,new_index|
        move_record_by_index old_index,new_index
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

    order_scope = OrderScope.where(:name => 'icebox').first
    order_scope ||= OrderScope.create :name => 'icebox', :data => []


    input :id => :textfield
    button(:class => 'btn',:text => 'add').click do
      get_element(:textfield).val do |value|
        i = Issue.new :description => value
        i.save!
        list = get_element(:list1)
        list.append_record i, :notify => true
      end
    end

    list :id => :list1 ,:sortable => true, :notify => true

    list = get_element(:list1)


    list.item_renderer do |record|
      div  :class => "well" do
        story_description = "#{record.id}: #{record.description}"
        div :text => story_description, :class => 'issue-description left'
        x = div :text => 'Delete', :class => 'btn danger right'
        x.click do
          list.remove record
        end
      end
    end


    list.onremove do |record|
      record.destroy
    end

    list.onsortupdate do
      order_scope.data = list.records_order
      order_scope.save!
    end

    list.load_records Issue.load_in_order(order_scope.data)

    issues_styling
#    initial_layout
#    setup_notificaitons
#    issue_events

  end

end

Nadeshiko::Server.run IssueTracker
