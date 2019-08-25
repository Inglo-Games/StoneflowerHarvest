#include <gdnative_api_struct.gen.h>
#include <string.h>

typedef struct user_data_struct {
    char data[256];
} user_data_struct;

void *simple_constructor(godot_object *p_instance, void *p_method_data);

void simple_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data);

godot_variant simple_get_data(godot_object *p_instance, void *p_method_data,
        void *p_user_data, int p_num_args, godot_variant **p_args);

int** sjte(int length);

int factorial(int n);

void swap(int* array, int a, int b);