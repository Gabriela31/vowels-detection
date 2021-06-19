function varargout = vocoder(varargin)
% VOCODER MATLAB code for vocoder.fig
%      VOCODER, by itself, creates a new VOCODER or raises the existing
%      singleton*.
%
%      H = VOCODER returns the handle to a new VOCODER or the handle to
%      the existing singleton*.
%
%      VOCODER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOCODER.M with the given input arguments.
%
%      VOCODER('Property','Value',...) creates a new VOCODER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vocoder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vocoder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vocoder

% Last Modified by GUIDE v2.5 14-May-2021 16:49:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vocoder_OpeningFcn, ...
                   'gui_OutputFcn',  @vocoder_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before vocoder is made visible.
function vocoder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vocoder (see VARARGIN)

% Choose default command line output for vocoder
handles.output = hObject;
handles.canvas_wav.Toolbar.Visible = 'on';
handles.canvas_frec.Toolbar.Visible = 'on';
handles.canvas_time.Toolbar.Visible = 'on';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vocoder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vocoder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_record.
function btn_record_Callback(hObject, eventdata, handles)
% hObject    handle to btn_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% leer los parametros de grabación
fs = str2double(get(handles.txt_fs, 'String'));
r = str2double(get(handles.txt_r, 'String'));
duracion = str2double(get(handles.txt_duracion, 'String'));

% crear elemento audio monocanal
my_audio = audiorecorder(fs,r,1,1); % monocanal

% grabar y pausar el audio
set(handles.txt_status,'String','Status: Recording...');
record(my_audio,duracion);
pause(duracion + 0.5); % pausa del sistema para que no exista error
set(handles.txt_status,'String','Status: Recorded');
my_signal = getaudiodata(my_audio,'double'); % vector donde se guardan los valores

%conversion todo a 8k de muestreo
if fs ~= 8000   
    [P,Q] = rat(8e3/fs);
    fs = 8e3;
    my_signal = resample(my_signal,P,Q);
end

% ploteo de la grabación
plot(handles.canvas_wav, 0:1/fs:duracion-1/fs, my_signal);
title(handles.canvas_wav,'Grabación')
ylabel(handles.canvas_wav,'Señal')
xlabel(handles.canvas_wav,'t (seg)')
grid(handles.canvas_wav,'on');

% actualización de los parametros
handles.fs = fs;
handles.r = r;
handles.duracion = duracion;
handles.my_audio = my_audio;
handles.my_signal = my_signal;
guidata(hObject,handles);


function txt_fs_Callback(hObject, eventdata, handles)
% hObject    handle to txt_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_fs as text
%        str2double(get(hObject,'String')) returns contents of txt_fs as a double


% --- Executes during object creation, after setting all properties.
function txt_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_duracion_Callback(hObject, eventdata, handles)
% hObject    handle to txt_duracion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_duracion as text
%        str2double(get(hObject,'String')) returns contents of txt_duracion as a double


% --- Executes during object creation, after setting all properties.
function txt_duracion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_duracion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_r_Callback(hObject, eventdata, handles)
% hObject    handle to txt_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_r as text
%        str2double(get(hObject,'String')) returns contents of txt_r as a double


% --- Executes during object creation, after setting all properties.
function txt_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_play.
function btn_play_Callback(hObject, eventdata, handles)
% hObject    handle to btn_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reproducir my_signal
handles.my_recorded_audio = audioplayer(handles.my_signal, handles.fs);
guidata(hObject,handles);
play(handles.my_recorded_audio);


% --- Executes on button press in btn_open.
function btn_open_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cargar la señal
[my_filename, my_folder] = uigetfile('*.wav');
my_file = my_folder + "" + my_filename; 
[handles.my_signal, handles.fs] = audioread(my_file);
handles.my_signal = handles.my_signal(:,1); % convertir a mono


%conversion todo a 8k de muestreo
if handles.fs ~= 8000   
    [P,Q] = rat(8e3/handles.fs);
    handles.fs = 8e3;
    handles.my_signal = resample(handles.my_signal,P,Q);
end

info = audioinfo(my_file);
handles.duration = info.Duration;

% ploteo de la grabación
dt = 1/handles.fs;
t = 0:dt:(length(handles.my_signal)*dt)-dt;
plot(handles.canvas_wav, t, handles.my_signal);
title(handles.canvas_wav,'Audio Cargado')
ylabel(handles.canvas_wav,'Señal')
xlabel(handles.canvas_wav,'t (seg)')
grid(handles.canvas_wav,'on');

handles.canvas_wav.Toolbar.Visible = 'on';
handles.canvas_frec.Toolbar.Visible = 'on';
handles.canvas_time.Toolbar.Visible = 'on';

% actualizar variables
guidata(hObject,handles);

% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = sprintf('test_%s.wav', datestr(now,'mm-dd-yyyy HH-MM-SS'));
audiowrite(filename, handles.my_signal, handles.fs)

% actualizar variables
guidata(hObject,handles);

% --- Executes on button press in btn_detectar.
function btn_detectar_Callback(hObject, eventdata, handles)
% hObject    handle to btn_detectar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% eliminar deteccion
handles.lista_vocales = {};
handles.listbox_index = {};

% separar en vocales
handles.energy = handles.my_signal.*handles.my_signal;
% handles.energy_logical = handles.energy > 0.01;
% handles.energy_logical = handles.energy > max(handles.energy)*(2.5/100);
handles.energy_logical = handles.energy > sum(handles.energy)/length(handles.energy);
disp(mean(handles.energy));

handles.comparador = zeros(1, 1000);
handles.comparador(1) = 1;
handles.com_index = strfind(handles.energy_logical.', handles.comparador);

handles.comparador2 = zeros(1, 1000);
handles.comparador2(end) = 1;
handles.com_index2 = strfind(handles.energy_logical.', handles.comparador2) + 1000;

% condiciones
if length(handles.com_index) ~= length(handles.com_index2)
    if (handles.com_index(1) > handles.com_index2(1))
        handles.com_index = [handles.com_index length(handles.energy)];
    end
    if (handles.com_index2(1) > handles.com_index(1))
        handles.com_index2 = [1 handles.com_index2];
    end
end

if length(handles.com_index) == length(handles.com_index2)
    if (handles.com_index2(1) > handles.com_index(1))
        handles.com_index = [handles.com_index length(handles.energy)];
        handles.com_index2 = [1 handles.com_index2];
    end
end

% guardar cada array de vocales en una struct
for i=1:length(handles.com_index)
    my_vocal = handles.my_signal(handles.com_index2(i):handles.com_index(i));
    handles.lista_vocales(i).senal = my_vocal;
    handles.lista_vocales(i).nombre = sprintf("Vocal %d",i);
    [handles.lista_vocales(i).X, handles.lista_vocales(i).frec] = freqz(my_vocal, 1, 8192, handles.fs);
    
    % arbol
    [h0,h1,f0,f1] = wfilters('db25');
    [B11,B12] = dwt(my_vocal', h0, h1);
    
    % nivel 2
    [B21,B22] = dwt(B11, h0, h1);
    [B23,B24] = dwt(B12, h0, h1);
    
    % nivel 3
    [B31,B32] = dwt(B21, h0, h1); 
    [B33,B34] = dwt(B22, h0, h1); 
    [B37,B38] = dwt(B24, h0, h1);
    
    % nivel 4
    [B41,B42] = dwt(B31, h0, h1);
    [B43,B44] = dwt(B32, h0, h1);
    [B45,B46] = dwt(B33, h0, h1);
    [B47,B48] = dwt(B34, h0, h1);
    [B413,B414] = dwt(B37, h0, h1);
    [B415,B416] = dwt(B38, h0, h1);
    
    % nivel 5
    [B53,B54] = dwt(B42, h0, h1); 
    [B55,B56] = dwt(B43, h0, h1); 
    [B57,B58] = dwt(B44, h0, h1); 
    [B59,B510] = dwt(B45, h0, h1);
    [B513,B514] = dwt(B47, h0, h1); 
    [B515,B516] = dwt(B48, h0, h1);
    [B525,B526] = dwt(B413, h0, h1);
    
    % nivel 6
    [B65,B66] = dwt(B53, h0, h1);
    [B67,B68] = dwt(B54, h0, h1);
    
    energy_b53 = B53*B53';
    energy_b54 = B54*B54';
    energy_b58 = B58*B58';
    energy_b65 = B65*B65';
    energy_b66 = B66*B66';
    energy_b68 = B68*B68';
    energy_b43 = B43*B43';
    energy_b45 = B45*B45';
    energy_b413 = B413*B413';
    energy_b415 = B415*B415';
    energy_b416 = B416*B416';
    
    handles.lista_vocales(i).value53 = energy_b53;
    handles.lista_vocales(i).value54 = energy_b54;
    handles.lista_vocales(i).value58 = energy_b58;
    
    handles.lista_vocales(i).value43 = energy_b43;
    handles.lista_vocales(i).value45 = energy_b45;
    handles.lista_vocales(i).value413 = energy_b413;
    handles.lista_vocales(i).value415 = energy_b415;
    handles.lista_vocales(i).value416 = energy_b416;
    
    
%     if(energy_b53 > energy_b58)
%         if(energy_b65 > energy_b66 && energy_b65 > energy_b68) % e-o
%             if(energy_b45 > energy_b43)
%                 handles.lista_vocales(i).vocal_identificada = "e";
%             else
%                 handles.lista_vocales(i).vocal_identificada = "o";
%             end
%         else % u - i 
%             if(energy_b45 > energy_b43)
%                 if(energy_b45 > energy_b413)
%                     handles.lista_vocales(i).vocal_identificada = "i";
%                 else
%                     handles.lista_vocales(i).vocal_identificada = "e2";
%                 end
%             else
%                 handles.lista_vocales(i).vocal_identificada = "u";
%             end
%         end
%     else
%         if(energy_b45 < energy_b413)
%             handles.lista_vocales(i).vocal_identificada = "i2";
%         else
%             handles.lista_vocales(i).vocal_identificada = "a";
%         end
%     end
    
    if(energy_b53 > energy_b58 || energy_b54 > energy_b58)
        if(energy_b54 > energy_b53)
            if(energy_b43 > energy_b413 && energy_b43 > energy_b415)
                handles.lista_vocales(i).vocal_identificada = "u";
            else
                handles.lista_vocales(i).vocal_identificada = "i";
            end
        else
            if(energy_b43 > energy_b45 && energy_b43 > energy_b416)
                handles.lista_vocales(i).vocal_identificada = "o";
            else
                handles.lista_vocales(i).vocal_identificada = "e";
            end
        end
    else
        handles.lista_vocales(i).vocal_identificada = "a";
    end
    
end

% crear listbox
for i=1:length(handles.lista_vocales)
    handles.listbox_index{i} = handles.lista_vocales(i).nombre;
end
set(handles.list_vocales,'string', handles.listbox_index);

% actualizar variables
guidata(hObject,handles);

% --- Executes on selection change in list_vocales.
function list_vocales_Callback(hObject, eventdata, handles)
% hObject    handle to list_vocales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_vocales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_vocales


% --- Executes during object creation, after setting all properties.
function list_vocales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_vocales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_play_vocal.
function btn_play_vocal_Callback(hObject, eventdata, handles)
% hObject    handle to btn_play_vocal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% obtener indice de la vocal
i = get(handles.list_vocales,'value');

% escribir en el label
set(handles.lbl_my_vocal,'String', handles.lista_vocales(i).vocal_identificada);

% reproducir my_signal
handles.my_recorded_audio = audioplayer(handles.lista_vocales(i).senal, handles.fs);
guidata(hObject,handles);
play(handles.my_recorded_audio);

% poner valores de bandas
set(handles.txt_value53,'String', handles.lista_vocales(i).value53);
set(handles.txt_value54,'String', handles.lista_vocales(i).value54);
set(handles.txt_value58,'String', handles.lista_vocales(i).value58);

set(handles.txt_value43,'String', handles.lista_vocales(i).value43);
set(handles.txt_value45,'String', handles.lista_vocales(i).value45);
set(handles.txt_value413,'String', handles.lista_vocales(i).value413);
set(handles.txt_value415,'String', handles.lista_vocales(i).value415);
set(handles.txt_value416,'String', handles.lista_vocales(i).value416);

% graficar en frecuencia
plot(handles.canvas_frec, handles.lista_vocales(i).frec, abs(handles.lista_vocales(i).X));
title(handles.canvas_frec,'Espectro de módulo de la vocal')
hold(handles.canvas_frec,'on')

% frecuencias altas
% banda B43
patch(handles.canvas_frec,[754 754 1000 1000],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'm','facecolor','m','edgecolor','m','facealpha',0.2,'edgealpha',0.2)
% banda B45
patch(handles.canvas_frec,[1750 1750 2000 2000],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'y','facecolor','y','edgecolor','y','facealpha',0.2,'edgealpha',0.2)
% banda B413
patch(handles.canvas_frec,[2000 2000 2250 2250],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'k','facecolor','k','edgecolor','k','facealpha',0.2,'edgealpha',0.2)

% banda B413
patch(handles.canvas_frec,[2000 2000 2250 2250],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'k','facecolor','k','edgecolor','k','facealpha',0.2,'edgealpha',0.2)

% banda B415
patch(handles.canvas_frec,[2750 2750 3000 3000],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'k','facecolor','k','edgecolor','k','facealpha',0.2,'edgealpha',0.2)

% banda B416
patch(handles.canvas_frec,[2500 2500 2750 2750],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'y','facecolor','y','edgecolor','y','facealpha',0.2,'edgealpha',0.2)


% frecuencias bajas
%banda B53
patch(handles.canvas_frec,[375 375 500 500],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'r','facecolor','r','edgecolor','r','facealpha',0.2,'edgealpha',0.2)

% banda B54
patch(handles.canvas_frec,[250 250 375 375],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'g','facecolor','g','edgecolor','g','facealpha',0.2,'edgealpha',0.2)

% banda B58
patch(handles.canvas_frec,[625 625 750 750],...
    [0 max(abs(handles.lista_vocales(i).X)) max(abs(handles.lista_vocales(i).X)) 0],...
    'c','facecolor','c','edgecolor','c','facealpha',0.2,'edgealpha',0.2)

% graficar la frec lo demas
ylabel(handles.canvas_frec,'Módulo')
xlabel(handles.canvas_frec,'Hz')
grid(handles.canvas_frec,'on');
grid(handles.canvas_frec,'minor');
hold(handles.canvas_frec,'off')

% graficar en el tiempo
dt = 1/handles.fs;
t = 0:dt:(length(handles.lista_vocales(i).senal)*dt)-dt;
plot(handles.canvas_time, t, handles.lista_vocales(i).senal);
title(handles.canvas_time,'Gráfica en el tiempo de la vocal')
ylabel(handles.canvas_time,'Señal')
xlabel(handles.canvas_time,'t (seg)')
grid(handles.canvas_time,'on');

handles.canvas_wav.Toolbar.Visible = 'on';
handles.canvas_frec.Toolbar.Visible = 'on';
handles.canvas_time.Toolbar.Visible = 'on';

% actualizar variables
guidata(hObject,handles);

% --- Executes on button press in btn_descompuesta.
function btn_descompuesta_Callback(hObject, eventdata, handles)
% hObject    handle to btn_descompuesta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% generar plot individuales y general
figure(1);

for i=1:length(handles.lista_vocales)
    subplot(2,length(handles.com_index),i);
    dt = 1/handles.fs;
    t = 0:dt:(length(handles.lista_vocales(i).senal)*dt)-dt;
    plot(t, handles.lista_vocales(i).senal);
    title("Muestra reconocida")
    xlabel("t")
    ylabel("Señal")
end

subplot(2,length(handles.com_index),[length(handles.com_index)+1 length(handles.com_index)*2]);
dt2 = 1/handles.fs;
t2 = 0:dt2:(length(handles.my_signal)*dt2)-dt2;
plot(t2, handles.my_signal);

hold on
for i=1:length(handles.com_index)
    plot([handles.com_index(i)/handles.fs handles.com_index(i)/handles.fs], [min(handles.my_signal), max(handles.my_signal)],'c-','LineWidth',2);
end

for i=1:length(handles.com_index2)
    plot([handles.com_index2(i)/handles.fs handles.com_index2(i)/handles.fs], [min(handles.my_signal), max(handles.my_signal)],'g-','LineWidth',2);
end

title("Descomposición de las señales de audio");
xlabel("t")
ylabel("Señal")
hold off
