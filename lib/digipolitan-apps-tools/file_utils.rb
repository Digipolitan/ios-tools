module Digipolitan

  class FileUtils

    def rename_files(pattern, replacement, path = ".", recursive = true)
      if pattern == nil || replacement == nil
        abort "Missing required parameters (pattern, replacement)"
      end
      entries = Dir.entries(path)
      entries.each do |entry|
        replaced = entry
        replaced_path = File.join(path, entry)
        if replaced_path != __FILE__
          if entry.include?(pattern)
            replaced = entry.gsub(pattern, replacement)
            replaced_path = File.join(path, replaced)
            File.rename(File.join(path, entry), replaced_path)
          end
          if recursive && File.directory?(replaced_path) && replaced != "." && replaced != ".."
            self.rename_files(pattern, replacement, replaced_path, recursive)
          end
        end
      end
    end
  end

  def replace_contents_of_files(pattern, replacement, path = ".", recursive = true)
    if pattern == nil || replacement == nil
      abort "Missing required parameters (pattern, replacement)"
    end
    entries = Dir.entries(path)
    entries.each do |entry|
      file_path = File.join(path, entry)
      if file_path != __FILE__
        if recursive && File.directory?(file_path) && entry != "." && entry != ".."
          self.replace_contents_of_files(pattern, replacement, file_path, recursive)
        elsif File.file?(file_path)
          content = File.read(file_path)
          if content.include?(pattern)
            self.write_to_file(file_path, content.gsub(pattern, replacement))
          end
        end
      end
    end
  end

  def write_to_file(path, content = "")
    File.open(path, "w") { |file|
      file.puts(content)
    }
  end

end
