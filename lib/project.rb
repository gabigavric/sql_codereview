class Project

  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      id = project.fetch("id").to_i
      title = project.fetch("title")
    projects.push(Project.new({:id => id, :title => title}))
  end
  projects
  end

  def ==(another_project)
      (self.title.==(another_project.title)).&(self.id.==(another_project.id))
  end

  def save
      project = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
      @id = project.first.fetch("id").to_i
  end

  def self.find(id)
      project = DB.exec("SELECT * FROM projects WHERE id = #{id};")
      title = project.first.fetch("title")
      Project.new({:title => title, :id => id})
  end

end
