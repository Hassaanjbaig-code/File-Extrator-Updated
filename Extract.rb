require("fileutils")

class FileExterer 
  def initialize
    @target_folder = ""
    @file_load = nil
    @file_extension = Hash.new { |hash, key| hash[key] = [] }
    @total_files = 0
    @moved_files = 0
  end

  def select_folder
    puts "Enter the folder to Extert"
    input_folder = gets.chomp
    load_data = "#{input_folder}/*"
    @file_load = Dir[load_data]
    sort_by_extension
  end

  def sort_by_extension
    @file_load.each do |file|
      file_ext = File.extname(file).delete(".")
      @file_extension[file_ext] << file
    end
    create_folder
  end

  def create_folder
    @total_files = @file_load.size
    @file_extension.each do |ext, files|
      @target_folder = "Result/#{ext}"
      FileUtils.mkdir_p(@target_folder)
      move_file(ext, files)
    end
  end

  def move_file(ext, files)
    files.dup.each do |file|
      next unless file
      filename = File.basename(file)
      FileUtils.mv(file, "#{@target_folder}/#{filename}")
      @file_extension[ext].delete(file)
      completed_percentage(ext)
    end
  end

  def completed_percentage(ext)
    @moved_files += 1
    percent = ((@moved_files.to_f / @total_files) * 100).round(2)
    puts "Moved #{@moved_files}/#{@total_files} files (#{percent}%)"
    puts "Doing this #{ext}"
  end
end

file = FileExterer.new

file.select_folder
