# Copyright (c) 2020-2024, NVIDIA CORPORATION.

from libcpp cimport bool
from libcpp.memory cimport unique_ptr

from pylibcudf.libcudf.scalar.scalar cimport scalar
from rmm.pylibrmm.memory_resource cimport DeviceMemoryResource


cdef class DeviceScalar:
    cdef public object c_value

    cdef object _dtype

    cdef const scalar* get_raw_ptr(self) except *

    @staticmethod
    cdef DeviceScalar from_unique_ptr(unique_ptr[scalar] ptr, dtype=*)

    cdef void _set_dtype(self, dtype=*)

    cpdef bool is_valid(DeviceScalar s)
