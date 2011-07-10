module Processor
  def process_text!(element, parent=nil)
    # Skip text nodes that lie outside of elements
    return unless parent
  end
  
  def process_title!(element)
    # Skip title nodes, they are taken care of by their respective parent's processors
  end
  
  def process_section!(element)
    id = element["id"]
    section = @association.owner.sections.create!(:title => element.xpath("title").text, 
                                                  :identifier => id)

    create!(:tag => "section", :identifier => id)
    
    # Process the children elements (paras, etc.) found within a section
    # Need to xpath to section here so that grabs children for that location
    # rather than the section itself
    element.xpath("section").children.each do |child|
      section.elements.send("process_#{child.name}!", child)
    end
  end
  
  def process_para!(element)
    element = create!(:tag => "para",
                      :identifier => element["id"])
   
  end
  
  def process_formalpara!(element)
    create!(:tag => "formalpara",
           :title => element.xpath("title").text,
           :content => element.to_xml,
           :identifier => element["id"])
  end
  
  def process_itemizedlist!(element)
    list = create!(:tag => "itemizedlist",
            :identifier => element["id"])
    element.xpath("listitem").children.each do |child|
      process_listitem!(list, child)
    end
    list
  end
  
  def process_listitem!(list, element)
    list.children.create!(:tag => "listitem",
                          :identifier => element["id"],
                          :content => element.to_xml)
  end
  
  def process_informalexample!(element)
    create!(:tag => "informalexample",
            :identifier => element["id"],
            :content => element.text)
  end
end