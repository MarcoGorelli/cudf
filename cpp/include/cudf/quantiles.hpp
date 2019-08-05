/*
 * Copyright (c) 2019, NVIDIA CORPORATION.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include "cudf.h"
#include "types.hpp"

namespace cudf {

std::pair<cudf::table, gdf_column>
group_quantiles(cudf::table const& input_table,
                gdf_column const& values,
                double quantile,
                gdf_quantile_method interpolation = GDF_QUANT_LINEAR,
                gdf_context const& context = gdf_context{});


} // namespace cudf
