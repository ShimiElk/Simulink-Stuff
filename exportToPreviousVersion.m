function result = exportToPreviousVersion(file, targetVersion)
%exportToPreviousVersion - This example uses a Simulink Project custom task
% to attempt export all Simulink model files to a previous version of
% MathWorks tools. 
    arguments
        file {mustBeNonzeroLengthText}
        targetVersion {mustBeText} = 'R2021b';
    
    end % arguments

    [modelFilepath, modelName, ext] = fileparts(file);
    if isempty(ext)
        error("File type is absence!\nThe file name, '%s' has no fle type\n",file)
    end % isempty(ext)
    
    switch ext
        case {".slx"}%{"mdl", ".slx"}        
            % Close all models first -- this code can error if hierarchies of
            % model references are open with unsaved changes, for example. 
            load_system(file);
            info = Simulink.MDLInfo(file);
             if info ~= targetVersion
                newName = [modelName '_' targetVersion ext];
                newFile = fullfile(modelFilepath, newName);
                if strcmp(newFile, 'file')
                    error('Remove existing file "%s" and rerun', newFile);
                end % strcmp(newFile, 'file')
                
                newFile1 = horzcat(newFile{:});
        
                exportedFile = Simulink.exportToVersion(modelName,newFile1,targetVersion);
    %             Simulink.exportToVersion(modelName,newFile1,targetVersion);
                close_system(modelName, 0);
                
                warning("off")
                pause(1/2); % Just to let the file system catch up
                mkdir (info.ReleaseName)
                copyfile(file, info.ReleaseName, 'f');
                % Could add the old back up file to the project here
                mkdir(targetVersion)
                movefile(exportedFile, targetVersion, 'f');
                result = sprintf("Created %s for use in %s, back up file in %s", ...
                    file, targetVersion, file);
                warning("on")
             end % info ~= targetVersion
        otherwise
            result = [];
    end %switch ext
end % end of functuin
